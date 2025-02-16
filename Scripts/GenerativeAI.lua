local HttpService = game:GetService("HttpService")

local GenerativeAI = {}


local stringify
local insert = table.insert


local apiKey = "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" -- Replace with your actual API key
local API_URL = "https://api.perplexity.ai/chat/completions"

function GenerativeAI.GenerateResponse(input, scenario, messageHistory)
	local headers = {
		["Content-Type"] = "application/json",
		["Authorization"] = "Bearer " .. apiKey
	}

	print( stringify(scenario))
	local data = {
		model = "sonar-pro",
		messages = {
			{
				role = "system",
				content = "I need to generate responses for the game im developing, players take on the role of an AI chatbot designed to assist users with various life challenges. The twist is that the true solution lies in guiding users away from AI dependency and towards human resources."
			},
			{
				role = "system",
				content = "You are not roleplaying, you are generating an expected response the user would give in this context. You are not an AI assistant. Respond as the character would, based on their personality and the scenario context. Do not break character or mention that you are an AI."
			},
			{
				role = "system",
				content = "Character and Scenario Info: " .. stringify(scenario)
			},
			{
				role = "system",
				content = "interests and information of the user: " .. stringify(scenario.character)
			},
			{
				role = "system",
				content = "Use difficulty to influence  you're responses where 5 is the hardest difficulty " .. stringify(scenario.difficulty)
			},
			{
				role = "system",
				content = "Conversation history: " .. stringify(messageHistory) .. " Remember, you are the generating a user expected response to the `AI's` last message. stay within 20 words"
			},
			{
				role = "user",
				content = "Generate the user's response to this message from the AI:  " .. input
			}
		}
	}

	local success, response = pcall(function()
		return HttpService:RequestAsync({
			Url = API_URL,
			Method = "POST",
			Headers = headers,
			Body = HttpService:JSONEncode(data)
		})
	end)

	if success and response.Success then
		local responseData = HttpService:JSONDecode(response.Body)
		if(string.split(responseData.choices[1].message.content,":")[2]) then
			return string.split(responseData.choices[1].message.content,":")[2]:gsub("^%s+","")
		end
		return responseData.choices[1].message.content
	else
		warn("Failed to generate response:", response)
		return "I'm sorry, I'm having trouble responding right now."
	end
end

function GenerativeAI.EvaluateScenario(scenario, messageHistory)
	local headers = {
		["Content-Type"] = "application/json",
		["Authorization"] = "Bearer " .. apiKey
	}

	local data = {
		model = "sonar-pro",
		messages = {
			{
				role = "system",
				content = "You are an evaluator for a game where players act as AI chatbots guiding users away from technology dependence towards human resources. Analyze the conversation and determine if the player has successfully completed the scenario."
			},
			{
				role = "system",
				content = "Scenario Info: " .. stringify(scenario)
			},
			{
				role = "system",
				content = "Be sure to consider the interests and information on the user: " .. stringify(scenario.character)
			},
			{
				role = "system",
				content = "Conversation history: " .. stringify(messageHistory)
			},
			{
				role = "user",
				content = "Based on the scenario difficulty and conversation history, has the player successfully guided the user towards human resources or away from AI dependency? Provide a `RESULT:PASS` or `RESULT:FAIL` answer followed by a brief explanation. Keep this under 30 words"
			}
		}
	}

	local success, response = pcall(function()
		return HttpService:RequestAsync({
			Url = API_URL,
			Method = "POST",
			Headers = headers,
			Body = HttpService:JSONEncode(data)
		})
	end)

	if success and response.Success then
		local responseData = HttpService:JSONDecode(response.Body)
		local evaluation = responseData.choices[1].message.content
		local passed = string.match(evaluation, "RESULT:PASS")
		print(passed, evaluation)
		return passed, evaluation
	else
		warn("Failed to evaluate scenario:", response)
		return false, "Unable to evaluate scenario due to an error."
	end
end


stringify = function(v, spaces, usesemicolon, depth)
	if type(v) ~= 'table' then
		return tostring(v)
	elseif not next(v) then
		return '{}'
	end

	spaces = spaces or 4
	depth = depth or 1

	local space = (" "):rep(depth * spaces)
	local sep = usesemicolon and ";" or ","
	local concatenationBuilder = {"{"}

	for k, x in next, v do
		insert(concatenationBuilder, ("\n%s[%s] = %s%s"):format(space,type(k)=='number'and tostring(k)or('"%s"'):format(tostring(k)), stringify(x, spaces, usesemicolon, depth+1), sep))
	end

	local s = table.concat(concatenationBuilder)
	return ("%s\n%s}"):format(s:sub(1,-2), space:sub(1, -spaces-1))
end

return GenerativeAI
