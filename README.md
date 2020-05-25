# Deno image with Distroless

This is a repository for a example of building a deno app utilizing a [Google Distroless Image](https://github.com/GoogleContainerTools/distroless)

This consist only of a Dockerfile, and there is a example app in the src folder.

The Dockerfile has some "hardcoded paths" that need to be defined if the default app is changed.

## Usage

```
docker build -t <name> .

If using the example provided in this repo, you need to open the port 5000 like the command below.
docker run --init --rm -p 5000:5000 <name>

```

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License
[MIT](https://choosealicense.com/licenses/mit/)