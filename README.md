# Pop Spot

Made for SpartaHack V

# Inspiration

While on a recent trip, I realized there was no real way for Uber / Taxi drivers to know where they should be waiting at in order to minimize their travel time in between pickups. Having a tool that helps them understand where they should be waiting at for their next pickup would allow then maximize their profits.

# What is does

Pop spot aggregates user data and makes predictions of where the most riders will be at a given time of day and day of week. We take this data and generate a realtime heatmap overlay on top of a map. The app also allows users to track their pickups for future reference.

# How we built it

We built this app primarily using native iOS development with Xcode and Swift. For our backend we are using AWS's suite of services. We have an api setup on api gateway that talks to various lambda functions and a dynamodb database. This will allow easy future scalability as needed. For the map functionality, we utilized multiple GCP apis. 

# Challenges we ran into

We initially started working on a different idea, but after 10 hours or so we decided that idea was no longer viable and we had to pivot. While developing the application, we had many issues implementing objective c GCP libraries into our project. We eventually figured out what was causing the problem, but we wasted a disproportional amount of time on this in specific. We also had some unforeseen delay issues while connecting our database to our API.


# Accomplishments we're proud of

The majority of the team has limited coding experience and has never done iOS development. With that being said, we are proud to have produced a functional application within the allotted time.

# What we learned

We learned a great deal about iOS development, dependency management, and GitHub workflows.

# Future

The potential applications of this project are pretty extensive. In addition to having users source the pickup data, this application could be acquired by a larger company and integrated into their software suite. This would allow their drivers to benefit from this application on a larger scale without having to manually track pickups.

## Authors

* **Nicholas Holbrook** - *iOS / Backend Development* - [ndh175](https://github.com/ndh175)
* **Stevie Price** - *Frontend Development* - [steviefp](https://github.com/steviefp)
* **Rafeek Farah** - *iOS Developer* - [rafeekf](https://github.com/rafeekf)
* **Joshua Mushkat** - *Asset Development* - [joshuaplastic](https://github.com/joshuaplastic)
