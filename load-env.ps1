# Load environment variables from .env file
if (Test-Path ".env") {
    Write-Host "Loading environment variables from .env file..." -ForegroundColor Yellow
    Get-Content ".env" | ForEach-Object {
        if ($_ -match "^([^#=]+)=(.*)$") {
            $name = $matches[1].Trim()
            $value = $matches[2].Trim()
            # Remove quotes if present
            $value = $value -replace '^["'']|["'']$', ''
            [Environment]::SetEnvironmentVariable($name, $value, "Process")
            Write-Host "Set: $name" -ForegroundColor Green
        }
    }
    Write-Host "Environment variables loaded successfully!" -ForegroundColor Green
} else {
    Write-Host ".env file not found - create one from env.example" -ForegroundColor Red
} 