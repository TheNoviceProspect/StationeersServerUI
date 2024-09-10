package discord

import (
	"StationeersServerUI/src/config"
	"fmt"

	"github.com/bwmarrin/discordgo"
)

func SendMessageToControlChannel(message string) {
	if config.DiscordSession == nil {
		fmt.Println("Discord session is not initialized")
		return
	}
	clearMessagesAboveLastN(config.ControlChannelID, 20)
	_, err := config.DiscordSession.ChannelMessageSend(config.ControlChannelID, message)
	if err != nil {
		fmt.Println("Error sending message to control channel:", err)
	} else {
		fmt.Println("Sent message to control channel:", message)
	}
}

func sendMessageToStatusChannel(message string) {
	if config.DiscordSession == nil {
		fmt.Println("Discord session is not initialized")
		return
	}
	clearMessagesAboveLastN(config.StatusChannelID, 10)
	_, err := config.DiscordSession.ChannelMessageSend(config.StatusChannelID, message)
	if err != nil {
		fmt.Println("Error sending message to status channel:", err)
	} else {
		fmt.Println("Sent message to status channel:", message)
	}
}

func SendMessageToSavesChannel(message string) {
	if config.DiscordSession == nil {
		fmt.Println("Discord session is not initialized")
		return
	}
	clearMessagesAboveLastN(config.SaveChannelID, 8)
	_, err := config.DiscordSession.ChannelMessageSend(config.SaveChannelID, message)
	if err != nil {
		fmt.Println("Error sending message to saves channel:", err)
	} else {
		fmt.Println("Sent message to saves channel:", message)
	}
}

// CONNECTION LIST
func updateConnectedPlayersMessage(channelID string) {
	content := formatConnectedPlayers()
	sendAndEditMessageInConnectedPlayersChannel(channelID, content)
}

func sendAndEditMessageInConnectedPlayersChannel(channelID, message string) {
	if config.DiscordSession == nil {
		fmt.Println("Discord session is not initialized")
		return
	}
	clearMessagesAboveLastN(config.ControlChannelID, 1)
	if config.ConnectedPlayersMessageID == "" {
		// Send a new message if there's no existing message to edit
		msg, err := config.DiscordSession.ChannelMessageSend(channelID, message)
		if err != nil {
			fmt.Printf("Error sending message to channel %s: %v\n", channelID, err)
		} else {
			config.ConnectedPlayersMessageID = msg.ID
			fmt.Printf("Sent message to channel %s: %s\n", channelID, message)
		}
	} else {
		// Edit the existing message
		_, err := config.DiscordSession.ChannelMessageEdit(channelID, config.ConnectedPlayersMessageID, message)
		if err != nil {
			fmt.Printf("Error editing message in channel %s: %v\n", channelID, err)
		} else {
			fmt.Printf("Updated message in channel %s: %s\n", channelID, message)
		}
	}
}

// BOT STATUS
func updateBotStatus(s *discordgo.Session) {
	playerCount := len(config.ConnectedPlayers)
	statusMessage := fmt.Sprintf("%d Employees connected", playerCount)
	err := s.UpdateGameStatus(0, statusMessage)
	if err != nil {
		fmt.Println("Error updating bot status:", err)
	}
}

// CLEAR MESSAGES
func clearMessagesAboveLastN(channelID string, keep int) {
	go func() {
		if config.DiscordSession == nil {
			fmt.Println("Discord session is not initialized")
			return
		}

		// Retrieve the last 100 messages in the channel (Discord API limit)
		messages, err := config.DiscordSession.ChannelMessages(channelID, 100, "", "", "")
		if err != nil {
			fmt.Printf("Error fetching messages from channel %s: %v\n", channelID, err)
			return
		}

		// If there are more than 'keep' messages, delete the excess ones
		if len(messages) > keep {
			for _, message := range messages[keep:] {
				err := config.DiscordSession.ChannelMessageDelete(channelID, message.ID)
				if err != nil {
					fmt.Printf("Error deleting message %s in channel %s: %v\n", message.ID, channelID, err)
				} else {
					fmt.Printf("Deleted message %s in channel %s\n", message.ID, channelID)
				}
			}
		}
	}()
}
