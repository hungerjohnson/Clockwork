--[[
	� 2014 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).

	Clockwork was created by Conna Wiles (also known as kurozael.)
	http://cloudsixteen.com/license/clockwork.html
--]]

--[[
	@codebase Shared
	@details Provides an interface for the language system.
	@field stored A table containing a list of stored languages.
--]]
Clockwork.lang = Clockwork.kernel:NewLibrary("Lang");
Clockwork.lang.stored = {};

CW_LANGUAGE_CLASS = {__index = CW_LANGUAGE_CLASS};

function CW_LANGUAGE_CLASS:Add(identifier, value)
	self[identifier] = value;
end;

--[[
	@codebase Shared
	@details Get the language table for the given language (or create if it doesn't exist.)
	@param String The language to get the table for.
	@returns The language table for the given language.
--]]
function Clockwork.lang:GetTable(name)
	if (!Clockwork.lang.stored[name]) then
		Clockwork.lang.stored[name] = Clockwork.kernel:NewMetaTable(
			CW_LANGUAGE_CLASS
		);
	end;
	
	return Clockwork.lang.stored[name];
end;

--[[
	@codebase Shared
	@details Get the language string for the given identifier.
	@param String The language which table to search.
	@param String The identifier to search for.
	@param Various A list of arguments to replace in the string.
	@returns The final string for the given identifier.
--]]
function Clockwork.lang:GetString(language, identifier, ...)
	local langString = self.stored[language][identifier];
	local arguments = {...};
	
	if (!langString) then
		langString = self.stored["English"][identifier] or identifier;
	end;
	
	for k, v in pairs(arguments) do
		langString = string.gsub(langString, "#"..k, tostring(v), 1);
	end;
	
	return langString;
end;

if (CLIENT) then
	function L(identifier, ...)
		local language = Clockwork.Client:GetData("Language");
		return Clockwork.lang:GetString(language, identifier, ...);
	end;
else
	function L(player, identifier, ...)
		local language = player:GetData("Language");
		return Clockwork.lang:GetString(language, identifier, ...);
	end;
end;