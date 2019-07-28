`nixpkgs/pkgs/top-level/haskell-packages.nix`

```nix
packageOverrides = self: super: {};
```

`nixpkgs/pkgs/development/haskell-modules/lib.nix`
- dontCheck = drv: ...
- addBuildDepend = drv: x: ...
- addBuildDepends = drv: xs: ...

check all packages
`nix-env -qaP -A nixpkgs.haskellPackages`
