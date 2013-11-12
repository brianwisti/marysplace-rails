# Mary's Place Client Tracker

[![Code Climate](https://codeclimate.com/github/brianwisti/marysplace-rails.png)](https://codeclimate.com/github/brianwisti/marysplace-rails)

[Mary's Place]: http://marysplaceseattle.org

This application was created to help the staff and volunteers of [Mary's Place][] record important client information.

## Features

* Client Checkins
* Incentive Points Tracking
* Incident reporting and followup

### TODO 

* Client Goal Tracking

## Requirements

* Ruby 1.9.3+
* NodeJS for JS runtime 

Much of the configuration assumes deployment to a Heroku instance, with 
external resources being hosted on Amazon Web Services. The following settings
are stored as environment variables.

* `AWS_ACCESS_KEY_ID`
* `AWS_BUCKET`
* `AWS_PAPERCLIP_ROOT`
* `AWS_SECRET_ACCESS_KEY`
* `SECRET_TOKEN`
* `TZ`

## Author

Brian Wisti <brian.wisti@gmail.com>

## License

Really? Um, ok. 

`app/assets/images/marys-place-icon.png` belongs to Mary's Place and nobody else.

The rest of it is MIT unless accompanied by a license which states otherwise.

> The MIT License (MIT)
> Copyright (c) 2012-2013 Brian Wisti
>
> Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
>
> The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
> 
> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
