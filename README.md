# CountrySearch
A coding challenge solution

Given the following task:
As a user, I want to see which country I’m currently in from the app and in the today widget. Additionally I should be able to search for a country using free text, capital city or language code sorted closest/furthest to my current location.

### Technical Details
API specification for search: ​https://restcountries.eu/#api-endpoints
For flag image Flagpedia can be used in this format: http://flagpedia.net/data/flags/normal/{{country​ code}}.png e.g. for Germany: ​http://flagpedia.net/data/flags/normal/de.png

### Acceptance Criteria
* As I open the app a list of countries should be shown from closest to furthest depending on my current location.
* I should be able to search for a country by:
  * name
  * capital city
  * language
* I should get the result in a list, which shows me the name of the country, picture of
the flag (if present), population and area size
* I should have access to the current country information from anywhere in the app.
* I should be able to see the current country information in the today widget
* Current country information I need to see:
  * Full name
  * Flag
  * Population
  * Capital
  * Region
  * Regional blocks
  * Language
  * Currency
  
---
  
### Author's notes
* Flagpedia seemed to be unreliable for some country codes, also it seemed to forward me to non TLS-pages, so I went with countryflags.io. Returns 64px only but it does the job. I also thought about just using emojis but I guess you want to see how I handle image loading ;-)

* I used CLGeocoder for the current user location because of reliability issues (see my remark in CountryService.swift)

* the search results are not necessarily order by distance. using a predicate driven search would be more interesting but also more complex so I kept it simple.

* the order button could be replaced by an alphabetical ordering button when no location is available (instead ob being useless)

* the current country only shows the first language in a collection of languages, same with the currency

* the app is not internationalized

* I partially covered one class to show possible tests and a rough approach to how I test

* all errors happen silently at this point with debug messages at most

* when it comes to localizing the widget is slow, also this is my first today widget.

* there is always room to improve but I think I would’ve easily gotten overboard since this task was comprehensive for a coding challenge as it is, the given specs should be satisfied, it is not a final product though.

---

### Requirements
The challenge solution has been implemented for iOS 12 in Swift 5.

### Copyright & License
Copyright (c) 2019 Andre Hoffmann - Released under the MIT license.
