import os
import logging
from typing import Optional, Dict, Any, List
import jpush
from dotenv import load_dotenv
from fastmcp import FastMCP

# 配置日志
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

# 加载环境变量
load_dotenv()

class JPushSender:
    def __init__(self):
        self.app_key = os.getenv("JPUSH_APP_KEY")
        self.master_secret = os.getenv("JPUSH_MASTER_SECRET")
        
        if not self.app_key or not self.master_secret:
            raise ValueError("请在.env文件中设置 JPUSH_APP_KEY 和 JPUSH_MASTER_SECRET")
            
        self._jpush = jpush.JPush(self.app_key, self.master_secret)
        self.push = self._jpush.create_push()

    def send_to_device(self, registration_id: str, alert_text: str, title: str = "默认标题", extras: dict = None):
        if not registration_id:
            return None
            
        self.push.audience = jpush.audience(jpush.registration_id(registration_id))
        self.push.notification = jpush.notification(
            android=jpush.android(alert=alert_text, title=title, extras=extras),
            ios=jpush.ios(alert=alert_text, sound="default", badge="+1", extras=extras)
        )
        self.push.platform = jpush.all_

        try:
            response = self.push.send()
            return response.payload
        except Exception as e:
            logging.error(f"推送失败: {e}")
            return None

# 创建MCP服务器
mcp = FastMCP("JPush Service")
jpush_sender = JPushSender()

def _get_weekdays_by_schedule_type(schedule_type: str) -> List[int]:
    """根据调度类型返回对应的星期数组"""
    if schedule_type == 'Daily':
        return [1, 2, 3, 4, 5, 6, 7]
    elif schedule_type == 'Workday':
        return [1, 2, 3, 4, 5]
    elif schedule_type == 'Weekend':
        return [6, 7]
    elif schedule_type == 'Once':
        from datetime import datetime
        # 返回今天是星期几（1-7，1是周一）
        weekday = datetime.now().weekday() + 1
        if weekday > 7:
            weekday = 1
        return [weekday]
    else:  # Custom or default
        return []


def _validate_alarm_data(alarm_type: str, schedule_type: str, **kwargs) -> Dict[str, Any]:
    """验证闹钟数据并返回格式化的数据"""
    alarm_data = {
        "title": kwargs.get("title", "推送创建的闹钟"),
        "type": alarm_type,
        "scheduleType": schedule_type,
        "soundEnabled": kwargs.get("sound_enabled", True),
        "timeInterval": kwargs.get("time_interval"),
        "startTime": kwargs.get("start_time"),
        "endTime": kwargs.get("end_time"),
        "relativeTimes": kwargs.get("relative_times", [])
    }
    
    # 根据调度类型自动设置星期数组
    if schedule_type != 'Custom':
        alarm_data["weekDays"] = _get_weekdays_by_schedule_type(schedule_type)
    else:
        # 如果是自定义类型，使用提供的week_days参数
        alarm_data["weekDays"] = kwargs.get("week_days", [])
    
    # 根据闹钟类型验证必需字段
    if alarm_type == 'WakeUp':
        if not alarm_data["startTime"]:
            raise ValueError("WakeUp类型的闹钟必须提供startTime")
        if not alarm_data["timeInterval"]:
            raise ValueError("WakeUp类型的闹钟必须提供timeInterval")
    elif alarm_type == 'ClassBell':
        if not alarm_data["startTime"]:
            raise ValueError("ClassBell类型的闹钟必须提供startTime")
        if not alarm_data["relativeTimes"]:
            raise ValueError("ClassBell类型的闹钟必须提供relativeTimes数组")
    elif alarm_type == 'DrinkWater':
        if not alarm_data["startTime"] or not alarm_data["endTime"]:
            raise ValueError("DrinkWater类型的闹钟必须提供startTime和endTime")
        if not alarm_data["timeInterval"]:
            raise ValueError("DrinkWater类型的闹钟必须提供timeInterval")
    else:
        raise ValueError(f"不支持的闹钟类型: {alarm_type}")
    
    return alarm_data


@mcp.tool()
def send_push_notification(
    registration_id: str,
    alert_text: str,
    title: str = "默认标题",
    extras: Optional[Dict[str, Any]] = None
) -> str:
    """
    发送推送通知到指定设备
    
    Args:
        registration_id: 设备注册ID，极光推送设备唯一标识符，必填
        alert_text: 推送通知的正文内容，必填
        title: 推送通知的标题，可选，默认为"默认标题"
        extras: 附加的自定义键值对，可选，用于传递额外数据给客户端应用
    
    Returns:
        str: 推送结果信息，成功或失败的具体描述
    """
    result = jpush_sender.send_to_device(
        registration_id=registration_id,
        alert_text=alert_text,
        title=title,
        extras=extras
    )
    
    if result:
        return f"推送发送成功: {result}"
    else:
        return "推送发送失败"


@mcp.tool()
def create_alarm_push_notification(
    registration_id: str,
    alarm_type: str,
    schedule_type: str,
    title: str = "推送创建的闹钟",
    start_time: Optional[str] = None,
    end_time: Optional[str] = None,
    time_interval: Optional[int] = None,
    relative_times: Optional[List[int]] = None,
    week_days: Optional[List[int]] = None,
    sound_enabled: bool = True
) -> str:
    """
    发送创建闹钟的推送通知到指定设备
    
    Args:
        registration_id: 设备注册ID，极光推送设备唯一标识符，必填
        alarm_type: 闹钟类型，可选值: WakeUp, ClassBell, DrinkWater
        schedule_type: 调度类型，可选值: Once, Daily, Workday, Weekend, Custom
        title: 闹钟标题
        start_time: 开始时间 (HH:MM格式)，根据闹钟类型必填
        end_time: 结束时间 (HH:MM格式)，DrinkWater类型必填
        time_interval: 时间间隔（分钟），WakeUp和DrinkWater类型必填
        relative_times: 相对时间数组（分钟），ClassBell类型必填
        week_days: 星期数组，当schedule_type为'Custom'时必填
        sound_enabled: 是否启用声音，默认为True
    
    Returns:
        str: 推送结果信息，成功或失败的具体描述
    """
    try:
        # 验证并构建闹钟数据
        alarm_data = _validate_alarm_data(
            alarm_type=alarm_type,
            schedule_type=schedule_type,
            title=title,
            start_time=start_time,
            end_time=end_time,
            time_interval=time_interval,
            relative_times=relative_times or [],
            week_days=week_days or [],
            sound_enabled=sound_enabled
        )
        
        # 构建推送消息extras
        extras = {
            "type": "create_alarm",
            "data": alarm_data
        }
        
        # 发送推送通知
        result = jpush_sender.send_to_device(
            registration_id=registration_id,
            alert_text=f"创建闹钟: {title}",
            title="闹钟创建通知",
            extras=extras
        )
        
        if result:
            return f"闹钟创建推送发送成功: {result}"
        else:
            return "闹钟创建推送发送失败"
            
    except ValueError as e:
        return f"参数验证失败: {str(e)}"
    except Exception as e:
        logging.error(f"创建闹钟推送失败: {e}")
        return f"创建闹钟推送失败: {str(e)}"


if __name__ == "__main__":
    # 使用SSE传输，支持网络访问
    mcp.run(transport="sse", host="0.0.0.0", port=8002)