#### Installation

As a first step, install this requirements;
* elixir 1.14.0-otp-25 version. 
* ffplay

Run the following command.
```elixir
chmod a+x ./about
```

Open the ~/.bashrc file and add the following line at the bottom.
```elixir
alias about='/path/to/about/file'
```
Then save the change by running the following command.
```elixir
source .bashrc 
```
It's done.

## Quick Start

The following query returns the translation of the given text:
```elixir
about --q desktop
```
![image](https://user-images.githubusercontent.com/62894501/194728091-601ab1b2-844d-40b8-b60f-759c4cc001a7.png)

For English response
```elixir
about --q desktop --l en
```
![image](https://user-images.githubusercontent.com/62894501/194728107-657c502a-657c-4d3b-b9fc-25e3aa3f8445.png)

For maximum of 100 queries
```elixir
about --q desktop --l en --n 100
```
![image](https://user-images.githubusercontent.com/62894501/194728119-9fb684cc-f6a1-4285-bfe7-49faba0b39d2.png)

For sound,
Available Options: [us, uk, au]
```elixir
about --q desktop --l en --n 100 --s us
```

For sound number of repetitions
```elixir
about --q desktop --l en --n 100 --s us --a 10
```
