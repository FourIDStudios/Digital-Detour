--|| References
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer


--|| Folders
local Assets = script:WaitForChild("Assets")
local Scenarios = script:WaitForChild("Scenarios"):GetChildren()

--|| Constants
local MaxScenarios = #Scenarios:GetChildren()

--|| Game State
local scenarioIndex = 1
local currentScenario = nil
local tokensRemaining = 0
local messages = {}

--|| Starts The Game
function Start()
	
end

--|| Loads A Scenario / Level
function LoadScenario()
	currentScenario = Scenarios[scenarioIndex]
	tokensRemaining = currentScenario.startingTokens
	messages = {}
	AddMessage(currentScenario.initialMessage, currentScenario.character.name)
end

--|| Function that adds the messages to the stream
function AddMessage(content:string, sender:string)
	local ChatBox = sender == "Player" and Assets.Right_Chat_Element:Clone() or Assets.Left_Chat_Element:Clone() 
	table.insert(messages, {content = content, sender = sender})

	
end

--|| Function that handles Player Input (MessageBox)
function ProcessPlayerInput()
	
end

--|| Evaluates the game state
function EvaluateScenario()
	-- Implement logic to determine if player passed or failed
	local success = 	DetermineSuccess()

	if success then
		if currentScenarioIndex < MaxScenarios then
			currentScenarioIndex = currentScenarioIndex + 1
		 	LoadScenario(currentScenarioIndex)
		else
		 	EndGame(true)
		end
	else
	 	EndGame(false)
	end
end

--|| Determines if the scenario has been succesfully passed
function DetermineSuccess()
	-- Implement your logic to determine if the scenario was successful
	-- This could involve analyzing the messages, checking for specific keywords, etc.
	return true -- Placeholder
end

--|| Ends the game
function EndGame(success)
	-- Implement game end logic
	print(success and "Game completed successfully!" or "Game over!")
end



