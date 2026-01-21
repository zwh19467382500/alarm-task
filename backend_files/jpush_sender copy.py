
import os
import jpush
from dotenv import load_dotenv
import logging

# 配置日志
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

class JPushSender:
    """
    一个简单的JPush推送类，用于向指定设备ID发送通知。
    """
    def __init__(self):
        """
        初始化JPushSender，从.env文件加载配置并初始化JPush客户端。
        """
        # 加载.env文件中的环境变量
        load_dotenv()
        
        self.app_key = os.getenv("JPUSH_APP_KEY")
        self.master_secret = os.getenv("JPUSH_MASTER_SECRET")
        
        if not self.app_key or not self.master_secret:
            raise ValueError("请在.env文件中设置 JPUSH_APP_KEY 和 JPUSH_MASTER_SECRET")
            
        # 初始化JPush
        self._jpush = jpush.JPush(self.app_key, self.master_secret)
        self.push = self._jpush.create_push()

    def send_to_device(self, registration_id: str, alert_text: str, title: str = "默认标题"):
        """
        向单个设备发送通知。

        :param registration_id: 设备的注册ID。
        :param alert_text: 通知的主要内容。
        :param title: 通知的标题。
        """
        if not registration_id:
            logging.error("Registration ID 不能为空")
            return

        # 构建推送对象
        self.push.audience = jpush.audience(jpush.registration_id(registration_id))
        self.push.notification = jpush.notification(
            android=jpush.android(alert=alert_text, title=title),
            ios=jpush.ios(alert=alert_text, sound="default", badge="+1")
        )
        self.push.platform = jpush.all_

        try:
            logging.info(f"准备向设备 {registration_id} 推送消息: '{alert_text}'")
            response = self.push.send()
            logging.info(f"推送成功，响应: {response.payload}")
            return response.payload
        except jpush.common.JPushFailure as e:
            logging.error(f"推送失败: {e}")
            return None
        except Exception as e:
            logging.error(f"发生未知错误: {e}")
            return None

# --- 使用示例 ---
if __name__ == "__main__":
    # 1. 创建JPushSender实例
    #    确保项目根目录下有.env文件，并包含您的JPUSH_APP_KEY和JPUSH_MASTER_SECRET
    try:
        sender = JPushSender()

        # 2. 设置您的设备ID
        #    请在此处填入您从客户端获取到的Registration ID
        your_device_id = "1507bfd3f6e5d694c3f" 

        # 3. 设置要推送的标题和内容
        push_title = "来自Python的问候"
        push_content = "这是一条通过Python脚本发送的极光推送消息。"

        # 4. 发送推送
        if your_device_id == "YOUR_REGISTRATION_ID_HERE":
            logging.warning("请在脚本中替换 'YOUR_REGISTRATION_ID_HERE' 为真实的设备ID")
        else:
            sender.send_to_device(your_device_id, push_content, push_title)
            
    except ValueError as e:
        logging.error(e)

