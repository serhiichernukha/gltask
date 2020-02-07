Configuration IISWebsite
{
    param(
        $NodeName
    )

    Node $NodeName
    {
        WindowsFeature IIS
        {
            Ensure = "Present"
            Name = "Web-Server"
        }
        WindowsFeature ASP
        {
            Ensure = "Present"
            Name = "Web-Asp-Net45"
        }
        File WebContent
        {
            Ensure = "Present"
            Type = "Directory"
            SourcePath = "C:\Content\BakeryWebsite"
            DestinationPath = "C:\inetpub\wwwroot\"
            Recurse = $true
        }
    }

} IISWebsite -NodeName "win_serv2"
