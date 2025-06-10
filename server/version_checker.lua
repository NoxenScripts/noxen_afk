local function checkLatestVersion()
    local repoUrl = "NoxenScripts/noxen_afk"
    local versionJsonUrl = "https://raw.githubusercontent.com/" .. repoUrl .. "/refs/heads/main/version.json"
    local apiUrl = "https://api.github.com/repos/" .. repoUrl .. "/releases/latest"

    PerformHttpRequest(versionJsonUrl, function(statusCode, versionResponse, headers)
        if statusCode == 200 then
            local versionData = json.decode(versionResponse)
            if versionData and versionData.version then
                local currentVersion = versionData.version

                PerformHttpRequest(apiUrl, function(releaseStatusCode, releaseResponse, releaseHeaders)
                    if releaseStatusCode == 200 then
                        local releaseData = json.decode(releaseResponse)
                        if releaseData and releaseData.tag_name then
                            local latestVersion = releaseData.tag_name:gsub("^v", "")

                            if latestVersion ~= currentVersion then
                                print("^3[Noxen Afk] ^7New version available!")
                                print("^3[Noxen Afk] ^7Current: ^2" .. currentVersion .. "^7, Latest: ^2" .. latestVersion)
                                print("^3[Noxen Afk] ^7Download: ^2" .. releaseData.html_url)
                            else
                                print("^2[Noxen Afk] ^7You are using the latest version: ^2" .. currentVersion)
                            end
                        end
                    else
                        print("^1[Noxen Afk] ^7Failed to check for latest release. Status code: " .. releaseStatusCode)
                    end
                end, "GET", "", {["User-Agent"] = "noxen-afk-updater"})

            end
        else
            print("^1[Noxen Afk] ^7Failed to fetch version.json from repository. Status code: " .. statusCode)
        end
    end, "GET", "", {["User-Agent"] = "noxen-afk-updater"})
end

Citizen.CreateThread(function()
    checkLatestVersion()

    while true do
        Citizen.Wait(30 * 60 * 1000)
        checkLatestVersion()
    end
end)