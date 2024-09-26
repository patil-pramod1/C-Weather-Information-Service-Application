<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Weather Information</title>
    <style>
        /* Reset styles */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Arial', sans-serif;
            line-height: 1.6;
            color: #333;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            height: 100vh;
            text-align: center;
            animation: fadeIn 1s ease;
            overflow: hidden;
            background-color: #87CEEB; /* Default background color */
            position: relative;
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        /* Main heading styles */
        h1 {
            margin-bottom: 20px;
            font-size: 3rem;
            color: #fff;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.5);
            letter-spacing: 1.5px;
        }

        /* Form container styles */
        .form-container {
            display: flex;
            justify-content: center;
            align-items: center;
            margin-bottom: 20px;
        }

        /* Input field styles */
        input[type="text"] {
            padding: 10px;
            border: 2px solid #fff;
            border-radius: 30px 0 0 30px; 
            width: 250px;
            outline: none;
            transition: border-color 0.3s, box-shadow 0.3s;
            font-size: 1rem;
        }

        input[type="text"]:focus {
            border-color: #ffeb3b;
            box-shadow: 0 0 5px rgba(255, 235, 59, 1);
        }

        /* Button styles */
        button {
            padding: 10px 20px;
            background-color: #ffeb3b;
            color: #333;
            border: none;
            border-radius: 0 30px 30px 0; 
            cursor: pointer;
            transition: background-color 0.3s, transform 0.3s;
            font-size: 1rem;
            font-weight: bold;
        }

        button:hover {
            background-color: #ffd600;
            transform: scale(1.05);
        }

        /* Result container styles */
        #result {
            padding: 20px;
            border-radius: 15px;
            background: rgba(255, 255, 255, 0.9);
            width: 300px;
            box-shadow: 0 4px 30px rgba(0, 0, 0, 0.2);
            transition: transform 0.3s;
            backdrop-filter: blur(10px);
        }

        /* Result text styles */
        #result h3 {
            margin-bottom: 10px;
            color: #00796b;
            font-size: 1.5rem;
        }

        #result p {
            margin: 5px 0;
            font-size: 1.2rem;
        }

        /* Loading animation */
        #loading {
            display: none;
            font-size: 1.2rem;
            color: #00796b;
        }

        .loader {
            border: 4px solid #f3f3f3; /* Light grey */
            border-top: 4px solid #3498db; /* Blue */
            border-radius: 50%;
            width: 30px;
            height: 30px;
            animation: spin 1s linear infinite;
            margin: 0 auto;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        /* Rain effect */
        .rain {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            pointer-events: none;
            background: url('rain.gif') repeat top center; /* Use a GIF for rain effect */
            opacity: 0.7;
            display: none; /* Hidden by default */
        }

        /* Sunshine effect */
        .sunshine {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            pointer-events: none;
            background: url('sunshine.gif') repeat top center; /* Use a GIF for sun effect */
            opacity: 0.5;
            display: none; /* Hidden by default */
        }
    </style>
    <script>
        async function fetchWeather() {
            let city = document.getElementById('city').value.trim();
            const resultDiv = document.getElementById('result');
            const loadingDiv = document.getElementById('loading');
            const rainEffect = document.querySelector('.rain');
            const sunshineEffect = document.querySelector('.sunshine');

            // Hide both effects initially
            rainEffect.style.display = 'none';
            sunshineEffect.style.display = 'none';

            if (!city) {
                resultDiv.innerHTML = "Please enter a city name.";
                return;
            }

            const encodedCity = encodeURIComponent(city);
            const requestUrl = '/weather?city=' + encodedCity;

            loadingDiv.style.display = 'block'; // Show loading animation
            resultDiv.innerHTML = ""; // Clear previous results

            try {
                const response = await fetch(requestUrl);
                let data = await response.json();

                if (response.ok) {
                    if (data.main && data.weather && data.wind) {
                    	var resultHtml = "<h3>Weather in " + city + ":</h3>";
                        resultHtml += "<p>Temperature: " + data.main.temp + "°C</p>";
                        resultHtml += "<p>Feels Like: " + data.main.feels_like + "°C</p>";
                        resultHtml += "<p>Min Temperature: " + data.main.temp_min + "°C</p>";
                        resultHtml += "<p>Max Temperature: " + data.main.temp_max + "°C</p>";
                        resultHtml += "<p>Humidity: " + data.main.humidity + "%</p>";
                        resultHtml += "<p>Weather: " + data.weather[0].description + "</p>";
                        resultHtml += "<p>Wind Speed: " + data.wind.speed + " m/s</p>";
                        resultDiv.innerHTML = resultHtml;

                        // Change background effect based on weather condition
                        changeBackground(data.weather[0].description);
                    } else {
                        resultDiv.innerHTML = "Weather data is incomplete.";
                    }
                } else {
                    resultDiv.innerHTML = data.error || "Unable to fetch weather information.";
                }
            } catch (error) {
                resultDiv.innerHTML = "An error occurred: " + error.message;
            } finally {
                loadingDiv.style.display = 'none'; // Hide loading animation
            }
        }

        function changeBackground(description) {
            const rainEffect = document.querySelector('.rain');
            const sunshineEffect = document.querySelector('.sunshine');

            if (description.includes("rain")) {
                rainEffect.style.display = 'block'; // Show rain effect
            } else if (description.includes("clear")) {
                sunshineEffect.style.display = 'block'; // Show sunshine effect
            } else {
                rainEffect.style.display = 'none'; // Hide rain effect
                sunshineEffect.style.display = 'none'; // Hide sunshine effect
            }
        }
    </script>
</head>
<body>
    <h1>Weather Information</h1>
    <div class="form-container">
        <input type="text" id="city" name="city" placeholder="Enter city name">
        <button onclick="fetchWeather()">Get Weather</button>
    </div>
    <div id="loading" style="display: none;">
        <div class="loader"></div>
        Loading...
    </div>
    <div id="result"></div>

    <!-- Background effects -->
    <div class="rain"></div>
    <div class="sunshine"></div>
</body>
</html>