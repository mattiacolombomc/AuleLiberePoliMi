import html
import json
import logging
import traceback
import os
from os.path import join, dirname
from telegram import Update, ParseMode
from telegram.ext import Updater, CallbackContext, CommandHandler


def error_handler(update: object, context: CallbackContext) -> None:
    """
    error handler function for the bot, notify the developer of any issue and
    send to him the stackstrace of the exception that occurred.
    Also notifies the user who triggered the error with a link to contact the developer.
    """
    DEVELOPER_CHAT_ID = os.environ.get("DEVELOPER_CHAT_ID")
    CHANNEL_ID = os.environ.get("CHANNEL_ID")

    logging.error(msg="Exception while handling an update:", exc_info=context.error)

    tb_list = traceback.format_exception(None, context.error, context.error.__traceback__)
    tb_string = ''.join(tb_list)

    update_str = update.to_dict() if isinstance(update, Update) else str(update)
    message = (
        f'An exception was raised while handling an update\n'
        f'<pre>update = {html.escape(json.dumps(update_str, indent=2, ensure_ascii=False))}'
        '</pre>\n\n'
        f'<pre>context.chat_data = {html.escape(str(context.chat_data))}</pre>\n\n'
        f'<pre>context.user_data = {html.escape(str(context.user_data))}</pre>\n\n'
        f'<pre>{html.escape(tb_string)}</pre>'
    )

    # Send detailed error to the private channel
    if CHANNEL_ID:
        try:
            context.bot.send_message(chat_id=CHANNEL_ID, text=message, parse_mode=ParseMode.HTML)
        except Exception as e:
            logging.error(f"Failed to send error message to channel: {e}")

    # Notify the user who triggered the error
    if isinstance(update, Update) and update.effective_message:
        user_message = (
            f"⚠️ Oops! Something went wrong while processing your request.\n\n"
            f"Please report this issue by clicking the button below:\n\n"
            f'<a href="tg://user?id={DEVELOPER_CHAT_ID}">📧 Contact Developer</a>'
        )
        try:
            update.effective_message.reply_text(user_message, parse_mode=ParseMode.HTML)
        except Exception as e:
            logging.error(f"Failed to send error notification to user: {e}")

# Helper functions for error messages and string builder

def bonk(update : Update , texts , lang):
    """
    function used to notify the users that they used a wrong input
    i.e. they didn't use the custom keyboards
    """
    update.message.reply_text(texts[lang]["texts"]['error']) 
    update.message.reply_photo(photo = open(join(dirname(__name__), 'photos/bonk.jpg'),'rb'))    

