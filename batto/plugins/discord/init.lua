-- discord plugin: send messages via webhook
-- Usage:
--   /discord         -- send message via Discord webhook (select channel)

local TIMES_DISCORD_WEBHOOK_URL = batto.env("TIMES_DISCORD_WEBHOOK_URL")

batto.command({
  name = "discord",
  description = "Send Discord message via webhook",
  args = {
    {
      name = "channel",
      required = true,
      type = "literal",
      choices = {
        -- Add your webhook channels here:
        -- { name = "General", value = "https://discord.com/api/webhooks/..." },
        { name = "times", value = TIMES_DISCORD_WEBHOOK_URL },
      },
    },
    { name = "message", required = true, type = "string" },
  },
  handler = function(args)
    local channel = args.channel or ""
    local message = args.message or ""
    return {
      {
        title = "Send to Discord: " .. message,
        exec = "curl -s -X POST '" ..
            channel .. "' -H 'Content-Type: application/json' -d '{\"content\":\"" .. message .. "\"}'",
      },
    }
  end,
})
