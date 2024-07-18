local Translations = {
    error = {
     	enter_gangzone = "You have entered a gang territory!",
    	leave_gangzone = "You have left a gang territory!",
    	hostile_zone = "Hostile Zone",
        member_not_connected = "Not enough enemy gang member connected!",
        zone_captured = "Zone has already been captured! I will be available after the next tsunami."
    }
}
Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
