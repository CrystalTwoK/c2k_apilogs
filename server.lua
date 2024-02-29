local QBCore = exports['qb-core']:GetCoreObject()

local SlackWebhooks = {
    ['default'] = 'https://hooks.slack.com/services/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',
    ['test'] = 'https://hooks.slack.com/services/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',
    ['azione'] = 'https://hooks.slack.com/services/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',
    ['death'] = 'https://hooks.slack.com/services/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',
    ['darkzone'] = 'https://hooks.slack.com/services/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',
    ['veicoli_rubati'] = 'https://hooks.slack.com/services/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',
    ['respawn'] = 'https://hooks.slack.com/services/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',
    ['revive'] = 'https://hooks.slack.com/services/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',
    ['identifiers'] = 'https://hooks.slack.com/services/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',
    ['inventario'] = 'https://hooks.slack.com/services/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',
    ['comandi_staff'] = 'https://hooks.slack.com/services/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',
    ['wipe'] = 'https://hooks.slack.com/services/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',
    ['stash'] = '',
    ['trunk'] = '',
    ['perquisizioni'] = '',
    ['me'] = 'https://hooks.slack.com/services/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',
    ['drops'] = 'https://hooks.slack.com/services/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',
    ['glovebox'] = '',
    ['crafting'] = '',
    ['streamer'] = 'https://hooks.slack.com/services/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',
    ['captagon'] = 'https://hooks.slack.com/services/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',
    ['join'] = 'https://hooks.slack.com/services/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',
    ['quit'] = 'https://hooks.slack.com/services/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',
}

RegisterServerEvent('c2k_apilogs:server:slackSend', function(name, message)
    local src = source
    local webHook = SlackWebhooks[name] or SlackWebhooks['default']

    print("LOGS SERVER RICEVUTO")

    if name == 'join' or name == 'quit' or name == 'identifiers' then
      
      local secondContent = {
        text = "HORDE",
        blocks = {
        {
    		  type = "section",
    		  text =  {
    			  type =  "mrkdwn",
    			  text =  message
    		  }
        }
      }
    }

      PerformHttpRequest(webHook, function() end, 'POST', json.encode(secondContent), { ['Content-Type'] = 'application/json' })
    else
      local playerName = GetPlayerName(src)
      local steamid  = ""
      local license  = ""
      local discord  = ""
      local xbl      = ""
      local liveid   = ""
      local ip       = ""

      for k,v in pairs(GetPlayerIdentifiers(src))do
        
        if string.sub(v, 1, string.len("steam:")) == "steam:" then
          if v then steamid = v:gsub('steam:', '') else steamid = "N/D" end
        elseif string.sub(v, 1, string.len("license:")) == "license:" then
          if v then license = v else license = "N/D" end
        elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
          if v then xbl  = v:gsub('xbl:', '') else xbl = "N/D" end
        elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
          if v then ip = v:gsub('ip:', '') else ip = "N/D" end
        elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
          if v then discord = v:gsub('discord:', '') else discord = "N/D" end
        elseif string.sub(v, 1, string.len("live:")) == "live:" then
          if v then liveid = v:gsub('live:', '') else liveid = "N/D" end
        end
    
      end

    if name == 'test' then message = "Ha eseguito un test del collegamento Webhook tramite le API di Slack" end
    local content = {
    text = "HORDE",
    blocks = {
        {
    		type = "section",
    		text =  {
    			type =  "mrkdwn",
    			text =  "*"..playerName.." | ID: "..src.."* \n```DISCORD: "..discord.."\nSTEAM HEX: "..steamid.."\nLICENZA: "..license.."```"
    		}
        },
        {
    		type = "section",
    		text =  {
    			type =  "mrkdwn",
    			text =  "```"..message.."```"
    		}
        }
    }
    }
      PerformHttpRequest(webHook, function() end, 'POST', json.encode(content), { ['Content-Type'] = 'application/json' })
    end
  end)

QBCore.Commands.Add('testslackconnection', 'Prova la connessione con il server Slack', {}, false, function(source, args)
    TriggerClientEvent('c2k_apilogs:client:slackSend', source, 'test', 'Webhook configurato con successo!')
end, 'god')
