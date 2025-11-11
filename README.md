# Aule Libere Polimi
Since the PoliMi site no longer allows people to search for free classrooms this bot was necessary!
It simply search for the classroom status on the chosen day and then find the free classroom using your preferred time slot. You can add it on telegram with this <a href="https://telegram.me/auleliberepolimi_bot">link</a>


<table>
  <tr>
    <td>Start</td>
     <td>Search</td>
     <td>Day</td>
  </tr>
  <tr>
    <td><img src="photos/README/start.png"></td>
    <td><img src="./photos/README/search.png"></td>
    <td><img src="./photos/README/day.png"></td>
  </tr>
 </table>

 # Set Up Your Personal Bot

## Dependencies
 If you have pipenv installed you could simply run the command:
 ```pipenv install``` and then ``` pipenv shell ``` to enter in the enviroment,
 otherwise you will have to install manually all the packages:
 ```
 beautifulsoup4
requests
python-telegram-bot
python-dotenv
 ```
 with the command :
 ``` pip install <package> ``` 
## Config
Now you simply have to create a ``` .env ``` file and insert the following environment variables:

```
TOKEN=YOUR_BOT_TOKEN
DEVELOPER_CHAT_ID=YOUR_TELEGRAM_USER_ID
CHANNEL_ID=YOUR_PRIVATE_CHANNEL_ID
ADMIN_ID=YOUR_ADMIN_USER_ID
```

### Environment Variables Explanation

- **TOKEN**: Your Telegram bot token obtained from BotFather
- **DEVELOPER_CHAT_ID**: Your personal Telegram user ID (used for error notifications and contact links)
- **CHANNEL_ID**: The ID of your private Telegram channel where error reports will be sent
- **ADMIN_ID**: Admin user ID for monitoring notifications

## Features

### Error Handling & Notifications
- **Channel Notifications**: When an exception occurs during bot operations, detailed error reports including stack traces are sent to your private channel (CHANNEL_ID)
- **User Feedback**: Users who trigger errors receive a friendly notification with a clickable link to contact the developer
- **Startup Notifications**: The bot sends a notification when it starts up, confirming it's online and operational

### Core Features
- Search for free classrooms across PoliMi campuses
- Quick search functionality with saved preferences
- Multi-language support (Italian and English)
- Customizable campus and time duration preferences
- Date and time selection with validation

# Credits

This bot is a fork of the original project by **[feDann](https://github.com/feDann/AuleLiberePoliMi)**, forked by **[zJudGenie](https://github.com/zJudGenie/AuleLiberePoliMi)**, and maintained and deployed by **[mattiacolombomc](https://github.com/mattiacolombomc/AuleLiberePoliMi)** (@admaiorasemper7 on Telegram).

For any issues or questions, please contact us on Telegram: [@admaiorasemper7](https://telegram.me/admaiorasemper7)

 # Disclaimer
This bot will work as long as the PoliMi website keeps the same layout

