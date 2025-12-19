// Advance through dialogue
if (visible) {
    message_index++;
    if (message_index >= array_length(messages)) {
        visible = false; // End dialogue
        message_index = 0;
    }
}
