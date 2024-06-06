# Function to get available printers from the specified server
function Get-AvailablePrinters {
    param (
        [string]$serverName
    )

    try {
        # Query the server for printers
        $printers = Get-WmiObject -Query "SELECT * FROM Win32_Printer" -ComputerName $serverName -ErrorAction Stop
        return $printers
    } catch {
        Write-Error "Impossible de récupérer les imprimantes du serveur '$serverName'. Assurez-vous que le nom du serveur est correct et que vous avez les permissions nécessaires."
        return $null
    }
}

# Function to display printers and get user choice
function Select-Printer {
    param (
        [array]$printers
    )

    if ($printers.Count -eq 0) {
        Write-Host "Aucune imprimante trouvée sur le serveur."
        return $null
    }

    Write-Host "Imprimantes disponibles :"
    for ($i = 0; $i -lt $printers.Count; $i++) {
        Write-Host "[$i] $($printers[$i].Name)"
    }

    $choice = Read-Host "Entrez le numéro de l'imprimante que vous souhaitez ajouter"
    if ($choice -match '^\d+$' -and [int]$choice -ge 0 -and [int]$choice -lt $printers.Count) {
        return $printers[$choice]
    } else {
        Write-Host "Choix invalide. Veuillez entrer un numéro valide."
        return $null
    }
}

# Main script
$serverName = Read-Host "Entrez le nom du serveur"
$printers = Get-AvailablePrinters -serverName $serverName

if ($printers) {
    $selectedPrinter = Select-Printer -printers $printers
    if ($selectedPrinter) {
        $printerPath = "\\$serverName\$($selectedPrinter.ShareName)"
        Add-Printer -ConnectionName $printerPath
        Write-Host "L'imprimante '$($selectedPrinter.Name)' a été ajoutée avec succès."
    } else {
        Write-Host "Aucune imprimante n'a été sélectionnée."
    }
}
