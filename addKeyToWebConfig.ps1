<#
   This script will add/update key in xml file.
   Here is updating web.config file with two pairs of settings.
   It would backup the orginial file fist and then update the orginial file.
#>

$inputFileName = ".\web.config"
$backUpFileName = ".\web_backup.config"
$key1 = "FirstName"
$value1 =  "Joey"
$key2 = "LastName"
$value2 = "Chen"


function BackUpFile ( [string]$fileName, [string]$outFileName)
{
	# Back up the file	
	Copy-Item $fileName -Destination $outFileName
}

function Add-FraudKey    ([string]$fileName, [string]$outFileName, [string]$key, [string]$value)    
{            
	# Load the config file up in memory            
	[xml]$xml = get-content $fileName;

	$appSettings = $xml.configuration.appSettings;
	# Find the app settings item to change            
	if($appSettings.selectsinglenode("add[@key='" + $key + "']"))
	{
	$appSettings.selectsinglenode("add[@key='" + $key + "']").value = $value
	}
	else
	{
	$newElement = $xml.CreateElement("add")
	$nameAtt1 = $xml.CreateAttribute("key")
	$nameAtt1.psbase.value = $key;
	$newElement.SetAttributeNode($nameAtt1);

	$nameAtt2 = $xml.CreateAttribute("value");
	$nameAtt2.psbase.value = $value;
	$newElement.SetAttributeNode($nameAtt2);

	$xml.configuration["appSettings"].AppendChild($newElement);
	$xml.save($fileName)
	}

	# Write it out to the new file            
	Format-XML $xml | out-file $outFileName    
}    

function Format-XML ([xml]$xml, $indent=2)    
{            
	$StringWriter = New-Object System.IO.StringWriter            
	$XmlWriter = New-Object System.XMl.XmlTextWriter $StringWriter            
	$xmlWriter.Formatting = "indented"            
	$xmlWriter.Indentation = $Indent            
	$xml.WriteContentTo($XmlWriter)            
	$XmlWriter.Flush()            
	$StringWriter.Flush()            
	Write-Output $StringWriter.ToString()    
}    

BackUpFile $inputFileName $backUpFileName
Add-FraudKey $inputFileName $inputFileName $key1 $value1
Add-FraudKey $inputFileName $inputFileName $key2 $value2