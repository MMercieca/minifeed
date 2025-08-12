# Introduction

Deployed at [minicast.app](https://minicast.app)

I listen to a lot of podcasts which put multiple shows on the same feed.  This makes catching up on older stories challenging since there can be a lot to scroll past in a podcast app.  Beyond that, some Patreon podcasts release multiple shows on a single feed.  While I want to follow some of the shows, I don't want to follow all of them.

Sorting and writing mini-RSS feeds was a lot easier than writing a podcast application. I was also a lot easier to share with other patrons of the same podcasts.

# Feedback

Feedback and tech support is available through the [minicast contact form](https://minicast.app/contact).

# Dependencies

* Ruby 3
* Rails 7
* Tailwind CSS

Everything should work after cloning the repo and doing a `bundle install`. 

# Authentication

I didn't want to deal with storing usernames and passwords, so all users will either need a Google account or a Patreon account.  This really helps cut down on spam submissions and I am only a one dev shop.

# TO DO

* Add demo video using The Adventure Zone
* Update feed editing UI
  * Add text or alt tags to make feed editing more obvious
  * Convert mini feed setup to a wizard?
* Add specs

# Done

* Update to rmajick (or something) to get off deprecated imgkit
* Added podcast checkup too to aid with diagnosing non-minicast feed issues
* Fixed security of AWS images
* Upgraded to Rails 7
* Upgraded to Heroku buildpack 24

Color pallet:
https://colors.muz.li/palette/ffa822/134e6f/ff6150/1ac0c6/dee0e6
