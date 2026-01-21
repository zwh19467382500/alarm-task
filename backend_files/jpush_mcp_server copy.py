import os
import logging
from typing import Optional, Dict, Any
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

if __name__ == "__main__":
    # 使用SSE传输，支持网络访问
    mcp.run(transport="sse", host="0.0.0.0", port=8002)