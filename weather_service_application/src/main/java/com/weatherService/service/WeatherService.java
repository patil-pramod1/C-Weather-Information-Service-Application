package com.weatherService.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.util.UriComponentsBuilder;

@Service
public class WeatherService {

    @Value("${openweathermap.api.key}")
    private String apiKey;

    public String getWeather(String city) {
        RestTemplate restTemplate = new RestTemplate();

        // Build the URI dynamically
        String weatherApiUrl = UriComponentsBuilder.fromHttpUrl("https://api.openweathermap.org/data/2.5/weather")
                .queryParam("q", city)
                .queryParam("appid", apiKey)
                .queryParam("units", "metric")
                .toUriString();

        try {
            String response = restTemplate.getForObject(weatherApiUrl, String.class);
            System.out.println("API Response: " + response);
            return response;
        } catch (HttpClientErrorException e) {
            System.out.println("API Error: " + e.getResponseBodyAsString());
            return "{\"error\":\"Unable to fetch weather information. Please try again.\"}";
        } catch (Exception e) {
            System.out.println("An unexpected error occurred: " + e.getMessage());
            return "{\"error\":\"An internal error occurred. Please try again.\"}";
        }
    }
}
