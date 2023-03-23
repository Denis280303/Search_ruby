# README

The search is based on 4 fields. Three of them are responsible for title, type and authors, and one more for exceptions or negative requests.
The program supports AJAX.

Things you may want to cover:

* Ruby version

'ruby "3.1.3"'

* Rails version

'gem "rails", "~> 7.0.4", ">= 7.0.4.2"'

* Services

The main logic has been transferred to the service. With the help of the service, there is a search in various fields, as well as a field for negative requests (unwanted requests). The service recognizes the number of entered words and selects different combinations if the words are not written in the correct order.

