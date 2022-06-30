# UV Forecast
[UV Forecast](https://wjwickham.com/uv-forecast) is a watchOS app that forecasts the UV index at your location. It has two views:
- **Today** shows an hour-by-hour timeline of conditions for 48 hours (excluding nighttime hours), along with the forecasted temperature.
- **Forecast** shows an 8-day timeline of the daily UV index high forecasts, along with the time of day that the high UV index is expected to be reached.

## Dark Sky API
UV Forecast uses [Dark Sky](https://darksky.net/poweredby) to source weather data. As Apple [now owns Dark Sky](https://blog.darksky.net/dark-sky-has-a-new-home/), it's unclear if (when) its API service may stop, at which time UV Forecast will need a new data source.

For now, it’s no longer possible to register a new API key to use with UV Forecast; if you already have an API key, you can use it in the app by putting it in a property list called Secrets.plist under the key `API_Key`.


