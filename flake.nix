{
    inputs = { } ;
    outputs =
        { self } :
            {
                lib =
                    {
                        config-identity ? x : x ,
                        implementation-identity ? x : x ,
                        lib-identity ? x : x ,
                        pkgs-identity ? x : x
                    } :
                        let
                            implementation =
                                { config , lib , ... } :
                                    let
                                        _config = config-identity config ;
                                        _lib = lib-identity lib ;
                                        in
                                            {
                                                options.trip =
                                                    _lib.mkOption
                                                        {
                                                            default =
                                                                { expression , message , uuid } :
                                                                    let
                                                                        eval = builtins.tryEval expression ;
                                                                        in
                                                                            if eval.success then eval.value
                                                                            else
                                                                                builtins.throw
                                                                                    (
                                                                                        builtins.toJSON
                                                                                            (
                                                                                                config.visitor
                                                                                                    { default = path : value : { type = builtins.typeOf value ; path = path ; value = builtins.toString value ; } ; }
                                                                                                    { lambda = path : value : { type = "lambda" ; path = path ; } ; }
                                                                                                    { uuid = uuid ; message = message ; }
                                                                                            )
                                                                                    ) ;
                                                            type = _lib.types.functionTo _lib.types.anything ;
                                                        } ;
                                            } ;
                            in
                                {
                                    check =
                                        {
                                            failure ?
                                                { lib , pkgs , ... } :
                                                    let
                                                        _lib = lib-identity lib ;
                                                        _pkgs = pkgs-identity pkgs ;
                                                        in
                                                            {
                                                                options.failure =
                                                                    _lib.mkOption
                                                                        {
                                                                            default = value : _pkgs.writeShellApplication { name = "failure" ; text = "echo 9519690907808385 >&2 exit 108" ; } ;
                                                                            type = _lib.types.functionTo _lib.types.package ;
                                                                        } ;
                                                            } ,
                                            visitor ?
                                                { lib , ... } :
                                                    let
                                                        _lib = lib-identity lib ;
                                                        in
                                                            {
                                                                options.visitor =
                                                                    _lib.mkOption
                                                                        {
                                                                            default = { ... } : { ... } : 8520609137972150 ;
                                                                            type = _lib.types.functionTo ( _lib.types.functionTo ( _lib.types.functionTo _lib.types.anything ) ) ;
                                                                        } ;
                                                            } ,
                                            nixosTest ,
                                            obviated-by
                                        } :
                                        {
                                            expression ,
                                            message ,
                                            uuid
                                        } :
                                        {
                                            success ,
                                            value
                                        } :
                                            {
                                                obviated-by = obviated-by ;
                                                test =
                                                    nixosTest
                                                        {
                                                            name = "nixos-test" ;
                                                            nodes.client =
                                                                { config , pkgs , ... } :
                                                                    let
                                                                        _config = config-identity config ;
                                                                        _pkgs = pkgs-identity pkgs ;
                                                                        in
                                                                            {
                                                                                config.environment.systemPackages =
                                                                                    [
                                                                                        (
                                                                                            _pkgs.writeShellApplication
                                                                                                {
                                                                                                    name = "test-script" ;
                                                                                                    runtimeInputs = [ ( _config.failure { } ) ] ;
                                                                                                    text =
                                                                                                        let
                                                                                                            expected = { success = success ; value = value ; } ;
                                                                                                            observed = builtins.tryEval ( _config.trip { expression = expression ; message = message ; uuid = uuid ; } ) ;
                                                                                                            in
                                                                                                                if expected == observed then ""
                                                                                                                else ''failure 7315078372437204'' ;
                                                                                                }
                                                                                        )
                                                                                    ] ;
                                                                                imports = [ failure implementation visitor ] ;
                                                                            } ;
                                                            testScript =
                                                                ''
                                                                    client.succeed("test-script")
                                                                '' ;
                                                        } ;
                                                type = "trip" ;
                                            } ;
                                    implementation = implementation ;
                                } ;
            } ;
}