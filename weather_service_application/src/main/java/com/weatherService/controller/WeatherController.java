package com.weatherService.controller;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.weatherService.service.WeatherService;

@Controller
public class WeatherController {
	
    @Autowired
    private WeatherService weatherService;

    // To return the JSP page
    @GetMapping("/")
    public String showWeatherPage() {
        return "weather";  // This should load weather.jsp
    }

    // API call to fetch the weather information
    @GetMapping("/weather")
    public ResponseEntity<String> getWeather(@RequestParam String city) {
        System.out.println("Received city: " + city);  // Log the received city name

        if (city == null || city.trim().isEmpty()) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                                 .body("{\"error\":\"City parameter is missing or empty.\"}");
        }

        try {
            String weatherData = weatherService.getWeather(city);
            return ResponseEntity.ok(weatherData);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                                 .body("{\"error\":\"An internal error occurred. Please try again.\"}");
        }
    }

}
