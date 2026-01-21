import os
import logging
from typing import Optional, Dict, Any
import jpush
from dotenv import load_dotenv
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import uvicorn
try:
    from fastmcp import FastMCP
    mcp = FastMCP("JPush Service")
except ImportError:
    logging.warning("FastMCP not available, MCP features will be disabled")
    mcp = None

# 配置日志
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

class PushRequest(BaseModel):
    registration_id: str
    alert_text: str
    title: str = "默认标题"
    extras: Optional[Dict[str, Any]] = None

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

    def send_to_device(self, registration_id: str, alert_text: str, title: str = "默认标题", extras: dict = None):
        """
        向单个设备发送通知。
        :param registration_id: 设备的注册ID。
        :param alert_text: 通知的主要内容。
        :param title: 通知的标题。
        :param extras: 自定义的键值对 (JSON)。
        """
        if not registration_id:
            logging.error("Registration ID 不能为空")
            return None

        # 构建推送对象
        self.push.audience = jpush.audience(jpush.registration_id(registration_id))
        self.push.notification = jpush.notification(
            android=jpush.android(alert=alert_text, title=title, extras=extras),
            ios=jpush.ios(alert=alert_text, sound="default", badge="+1", extras=extras)
        )
        self.push.platform = jpush.all_

        try:
            logging.info(f"准备向设备 {registration_id} 推送消息: '{alert_text}' 并附带 extras: {extras}")
            response = self.push.send()
            logging.info(f"推送成功，响应: {response.payload}")
            return response.payload
        except jpush.common.JPushFailure as e:
            logging.error(f"推送失败: {e}")
            return None
        except Exception as e:
            logging.error(f"发生未知错误: {e}")
            return None

# FastAPI应用
app = FastAPI(title="JPush推送服务", version="1.0.0")
jpush_sender = None

@app.on_event("startup")
async def startup_event():
    global jpush_sender
    try:
        jpush_sender = JPushSender()
        logging.info("JPush服务初始化成功")
    except ValueError as e:
        logging.error(f"JPush服务初始化失败: {e}")
        sys.exit(1)

# 共享的推送逻辑
def _send_push_logic(registration_id: str, alert_text: str, title: str = "默认标题", extras: Optional[Dict[str, Any]] = None):
    """内部推送逻辑"""
    if not jpush_sender:
        return {"success": False, "error": "JPush服务未初始化"}
    
    result = jpush_sender.send_to_device(
        registration_id=registration_id,
        alert_text=alert_text,
        title=title,
        extras=extras
    )
    
    if result:
        return {"success": True, "data": result}
    else:
        return {"success": False, "error": "推送发送失败"}

# FastAPI接口
@app.post("/send-push")
async def send_push(request: PushRequest):
    """
    发送推送消息到指定设备
    """
    result = _send_push_logic(
        registration_id=request.registration_id,
        alert_text=request.alert_text,
        title=request.title,
        extras=request.extras
    )
    
    if result["success"]:
        return result
    else:
        raise HTTPException(status_code=500, detail=result["error"])

# FastMCP工具
if mcp:
    @mcp.tool()
    def send_push_mcp(registration_id: str, alert_text: str, title: str = "默认标题", extras: Optional[Dict[str, Any]] = None) -> str:
        """
        发送推送消息到指定设备
        """
        result = _send_push_logic(
            registration_id=registration_id,
            alert_text=alert_text,
            title=title,
            extras=extras
        )
        
        if result["success"]:
            return f"推送发送成功: {result['data']}"
        else:
            return f"推送发送失败: {result['error']}"

@app.get("/health")
async def health_check():
    """
    健康检查接口
    """
    return {"status": "healthy", "service": "jpush-service"}

def main():
    """启动FastAPI服务"""
    import argparse
    parser = argparse.ArgumentParser(description="JPush推送服务")
    parser.add_argument("--host", default="0.0.0.0", help="绑定的主机地址")
    parser.add_argument("--port", type=int, default=8001, help="绑定的端口")
    args = parser.parse_args()
    
    logging.info(f"启动JPush推送服务在 {args.host}:{args.port}...")
    uvicorn.run(app, host=args.host, port=args.port)

if __name__ == "__main__":
    main()