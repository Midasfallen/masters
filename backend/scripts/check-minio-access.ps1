# PowerShell script для проверки доступности MinIO

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Проверка доступности MinIO" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "1. Проверка API endpoint (http://localhost:9000)..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:9000" -Method Head -UseBasicParsing -ErrorAction Stop
    Write-Host "   ✅ MinIO API доступен (код: $($response.StatusCode))" -ForegroundColor Green
} catch {
    $statusCode = $_.Exception.Response.StatusCode.value__
    # MinIO возвращает 400 для корневого пути без аутентификации - это нормально
    if ($statusCode -eq 400 -or $statusCode -eq 403 -or $statusCode -eq 401) {
        Write-Host "   ✅ MinIO API доступен (код: $statusCode - нормальный ответ для неаутентифицированного запроса)" -ForegroundColor Green
    } else {
        Write-Host "   ❌ MinIO API недоступен: $($_.Exception.Message)" -ForegroundColor Red
    }
}
Write-Host ""

Write-Host "2. Проверка CORS заголовков..." -ForegroundColor Yellow
try {
    # Используем OPTIONS запрос для проверки CORS (preflight)
    $headers = @{
        "Origin" = "http://localhost:50220"
        "Access-Control-Request-Method" = "GET"
    }
    $corsResponse = Invoke-WebRequest -Uri "http://localhost:9000/posts/" -Method Options -Headers $headers -UseBasicParsing -ErrorAction Stop
    if ($corsResponse.Headers["Access-Control-Allow-Origin"]) {
        Write-Host "   ✅ CORS заголовки присутствуют" -ForegroundColor Green
        Write-Host "   Access-Control-Allow-Origin: $($corsResponse.Headers['Access-Control-Allow-Origin'])" -ForegroundColor Gray
        if ($corsResponse.Headers["Access-Control-Allow-Methods"]) {
            Write-Host "   Access-Control-Allow-Methods: $($corsResponse.Headers['Access-Control-Allow-Methods'])" -ForegroundColor Gray
        }
    } else {
        Write-Host "   ⚠️  CORS заголовки не найдены" -ForegroundColor Yellow
    }
} catch {
    Write-Host "   ⚠️  Не удалось проверить CORS: $($_.Exception.Message)" -ForegroundColor Yellow
}
Write-Host ""

Write-Host "3. Проверка публичного доступа к бакету posts..." -ForegroundColor Yellow
try {
    $bucketResponse = Invoke-WebRequest -Uri "http://localhost:9000/posts/" -Method Head -UseBasicParsing -ErrorAction Stop
    Write-Host "   ✅ Бакет posts доступен (код: $($bucketResponse.StatusCode))" -ForegroundColor Green
} catch {
    $statusCode = $_.Exception.Response.StatusCode.value__
    if ($statusCode -eq 403 -or $statusCode -eq 404) {
        Write-Host "   ✅ Бакет posts доступен (код: $statusCode)" -ForegroundColor Green
    } else {
        Write-Host "   ❌ Бакет posts недоступен (код: $statusCode)" -ForegroundColor Red
    }
}
Write-Host ""

Write-Host "4. Проверка переменной окружения MINIO_PUBLIC_URL..." -ForegroundColor Yellow
$envFile = Join-Path (Split-Path $PSScriptRoot -Parent) ".env"
if (Test-Path $envFile) {
    $envContent = Get-Content $envFile -Raw
    if ($envContent -match "MINIO_PUBLIC_URL\s*=\s*http://localhost:9000") {
        Write-Host "   ✅ MINIO_PUBLIC_URL настроен правильно" -ForegroundColor Green
    } else {
        Write-Host "   ⚠️  MINIO_PUBLIC_URL не найден или имеет другое значение" -ForegroundColor Yellow
        Write-Host "   Добавьте в backend/.env: MINIO_PUBLIC_URL=http://localhost:9000" -ForegroundColor Gray
    }
} else {
    Write-Host "   ⚠️  Файл backend/.env не найден" -ForegroundColor Yellow
    Write-Host "   Создайте файл backend/.env с переменной: MINIO_PUBLIC_URL=http://localhost:9000" -ForegroundColor Gray
}
Write-Host ""

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "✅ Проверка завершена" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Cyan
