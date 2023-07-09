# **Introduction to Servant**
This repository contains sample code for exploring the [Servant](https://hackage.haskell.org/package/servant) framework. We'll look at a few simple samples adapted from the [Servant tutorial](https://docs.servant.dev/en/stable/tutorial/index.html) (`src/App1_2`, `src/App3`), as well as something closer to a real-world example in the form of a To Do app (`src/Todo`, adapted from [Todo-Backend](https://github.com/jhedev/todobackend-haskell/tree/master/todobackend-servant)).

## **Setup**
The application can be built and run using either Nix or Cabal.

### **Nix (recommended)**
If you use Nix, you can build the application from the `flake.nix` file, which will install compatible versions of the Haskell toolchain as well as a preconfigured VS Codium editor you can use to explore the code.

You must have the following `experimental-features` enabled in your Nix configuration (`/etc/nix/nix.conf`):

```
# /etc/nix/nix.conf

experimental-features = flakes nix-command
```

**🚨 IMPORTANT!** You must restart the `nix-daemon` after modifying `nix.conf` to apply the changes

**Linux:**

  ```sh
  sudo systemctl restart nix-daemon
  ```

**MacOS:**

  ```sh
  sudo launchctl stop org.nixos.nix-daemon
  sudo launchctl start org.nixos.nix-daemon
  ```

After cloning the repository, enter the `servant-tutorial` directory and run `nix develop` to enter the Nix environment (if you use `direnv`, you can instead run `direnv allow` when you enter the directory).

Once the dependencies finish building, you can run `codium .` to open a preconfigured VS Codium instance with IDE support. Run `cabal build` in the integrated terminal to build the project.

### **Cabal**
Running the application with Cabal only (without Nix) requires a version of GHC `>= 9.2.5` and `< 9.4`, Cabal `>= 3.0`, and a compatible version of Haskell Language Server (HLS).

Use [GHCup](https://www.haskell.org/ghcup/) to install the required tooling and `ghcup tui` to adjust versions as needed.

You can then build the project via `cabal build`.

## **Running the App**
If you're not using `direnv`, you'll need to set two environment variables in your terminal session:

```sh
HOST=localhost
PORT=8080
```

Then you can serve the first sample app using the following command:

```
cabal run servant-tutorial -- app1
```

This will initialize a server running `app1` on the specified host and port.

Go to `http://localhost:8080/users` to confirm the server is working (you should see a JSON object containing some user data).