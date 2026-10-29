{
    inputs = { } ;
    outputs =
        { self } :
            {
                lib =
                    { input ? null , output ? null } :
                        let
                            implementation =
                                { config , lib , ... } @module :
                                    let
                                        identified =
                                            if builtins.typeOf input == "lambda" then input module
                                            else if builtins.typeOf input == "null" then module
                                            else builtins.throw "4956372387227342" ;
                                        in
                                            with identified ;
                                                {
                                                    options.trip =
                                                        lib.mkOption
                                                            {
                                                                default =
                                                                    uuid :
                                                                        builtins.throw
                                                                            (
                                                                                builtins.toJSON
                                                                                    (
                                                                                        config.visitor
                                                                                            { default = path : value : { type = builtins.typeOf value ; path = path ; value = builtins.toString value ; } ; }
                                                                                            { lambda = path : value : { type = "lambda" ; path = path ; } ; }
                                                                                            uuid
                                                                                    )
                                                                            ) ;
                                                                type = lib.types.functionTo lib.types.anything ;
                                                            } ;
                                                } ;
                            in
                                {
                                    check =
                                        {
                                            failure ?
                                                { lib , pkgs , ... } :
                                                    let
                                                        identified =
                                                            if builtins.typeOf input == "lambda" then input module
                                                            else if builtins.typeOf input == "null" then module
                                                            else builtins.throw "63023801548262072" ;
                                                        in
                                                            with identified ;
                                                                {
                                                                    options.failure =
                                                                        lib.mkOption
                                                                            {
                                                                                default = value : pkgs.writeShellApplication { name = "failure" ; text = "echo 9519690907808385 >&2 exit 108" ; } ;
                                                                                type = lib.types.functionTo lib.types.package ;
                                                                            } ;
                                                                } ,
                                            nixosTest ,
                                            obviated-by ,
                                            visitor ?
                                                { lib , ... } :
                                                    let
                                                        identified =
                                                            if builtins.typeOf input == "lambda" then input module
                                                            else if builtins.typeOf input == "null" then module
                                                            else builtins.throw "4028316442555919" ;
                                                        in
                                                            with identified ;
                                                                {
                                                                    options.visitor =
                                                                        lib.mkOption
                                                                            {
                                                                                default = { ... } : { ... } : 8520609137972150 ;
                                                                                type = lib.types.functionTo ( lib.types.functionTo ( lib.types.functionTo lib.types.anything ) ) ;
                                                                            } ;
                                                                }
                                        } :
                                        {
                                            uuid
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
                                                                        identified =
                                                                            if builtins.typeOf input == "lambda" then input module
                                                                            else if builtins.typeOf input == "null" then module
                                                                            else builtins.throw "4028316442555919" ;
                                                                        in
                                                                            with identified ;
                                                                                {
                                                                                    config.environment.systemPackages =
                                                                                        [
                                                                                            (
                                                                                                pkgs.writeShellApplication
                                                                                                    {
                                                                                                        name = "test-script" ;
                                                                                                        runtimeInputs = [ ( config.failure { } ) ] ;
                                                                                                        text =
                                                                                                            let
                                                                                                                eval = builtins.tryEval ( config.trip uuid ) ;
                                                                                                                in
                                                                                                                    if eval.success then ''failure 7315078372437204''
                                                                                                                    else "" ;
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
                                    implementation =
                                        if builtins.typeOf output == "lambda" then output implementation
                                        else if builtins.typeOf output == "null" then implementation
                                        else builtins.throw "7596222792690922" ;
                                } ;
            } ;
}