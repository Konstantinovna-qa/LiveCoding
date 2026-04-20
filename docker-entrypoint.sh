#!/bin/sh
set -e

echo "Starting container..."
echo "Python: $(python --version)"
echo "Pytest: $(pytest --version)"
echo "Allure: $(allure --version || true)"
echo "Chromium: $(chromium-browser --version || chromium --version || true)"
echo "ChromeDriver: $(chromedriver --version || true)"

exec "$@"