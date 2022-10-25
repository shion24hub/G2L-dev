from flask import (
    Flask,
    request,
    abort,
    render_template
)
from linebot import LineBotApi, WebhookHandler
from linebot.exceptions import InvalidSignatureError
from linebot.models import MessageEvent, TextMessage, TextSendMessage
import os

app = Flask(__name__)

CHANNEL_ACCESS_TOKEN = os.environ["CHANNEL_ACCESS_TOKEN"]
CHANNEL_SECRET = os.environ["CHANNEL_SECRET"]
TEST_USER_ID = os.environ["TEST_USER_ID"]

line_bot_api = LineBotApi(CHANNEL_ACCESS_TOKEN)
handler = WebhookHandler(CHANNEL_SECRET)

@app.route("/")
def Startup_check() :
    return render_template(
        "startup_check.html"
    )


# When a function of google cloud functions is executed, a post request is sent to this URL.
@app.route("/api", methods=["POST"])
def api() :

    name = request.form["name"]

    message = "postリクエストを受信しました。name : {}".format(name)
    line_bot_api.push_message(
        TEST_USER_ID,
        messages=TextSendMessage(message))

    return "access!"


@app.route("/callback", methods=['POST'])
def callback():
    signature = request.headers['X-Line-Signature']

    body = request.get_data(as_text=True)
    app.logger.info("Request body: " + body)

    try:
        handler.handle(body, signature)
    except InvalidSignatureError:
        abort(400)

    return 'OK'

@handler.add(MessageEvent, message=TextMessage)
def handle_message(event):
    profile = line_bot_api.get_profile(event.source.user_id)

    message = "あなたのuser ID は、{}です。".format(profile.user_id)

    line_bot_api.reply_message(
        event.reply_token,
        TextSendMessage(text=message)
    )

if __name__ == "__main__" :
    port = int(os.getenv("PORT", 5000))
    app.run(
        host="0.0.0.0",
        port=port,
    )