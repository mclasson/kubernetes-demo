# Script for creating a small k8s cluster in Azure
Perform the prerequisites first!  

## ENVIRONMENT
1. Login to Azure portal and setup your small Kubernetes cluster. Use default setting except for Http application routing. Change that to Yes.  
2. Open a command prompt and run ``` az login ``` to logon and cache credentials to Azure.
3. Run ``` az aks use-dev-spaces -g <resource group for cluster> -n <clustername> ``` to install the Dev-spaces controller in Azure and locally.

## CODE
1. Create a simple web project by running ``` dotnet new mvc --name frontend ```
2. cd into the new folder and run ``` code . ``` to open VS Code.
3. Init azds for the project by running ``` azds prep --public ```. Public is to enable public http for that service. A number of files is now added to the folder like DockerFile and azds.yaml.
4. Now just run ``` azds up ``` to build, publish and launch the app in the cluster. You are presented with two urls in the console window. One for the public address to the service and one SSL'd to a localhost address.

## DEBUG
1. In VS Code hit Ctrl+Shift+P to open Command Palette and start typing ``` Azure Dev ``` . You should now see Prepare configuration files for Azure Dev Spaces. Run the command.
![images](images/commandpalette.png)
2. In debug pane you should now have a configuration called ".NET Core Launch (AZDS)". If not, restart VS Code.
3. With that configuration active, hit F5. Problems? Restart VS Code. It's a first time kind of thing.
4. Add a breakpoint in your code and browse to the site.

## INTERESTING
Now create a second service as a webapi by doing the following
1. Run ``` dotnet new webapi --name backend ```
2. cd into the folder _backend_ and run ``` code . ```
3. Init azds for the project by running ``` azds prep  ```. Notice the lack of ``` --public ```? This is because the backend should be exposed to the public.
4. Either you get a notification that Dev-Spaces is missing some files and you click _Yes_ or you press Shift+Ctrl+P and type ``` Azure Dev ``` like above to create the profile for debugging.
5. Now, modify the first project _frontend_ in the controller for, like, _About_ to the following
```cs
        public async Task<IActionResult> About()
        {
            ViewData["Message"] = "Your application description page.";
            using (var client = new System.Net.Http.HttpClient())
            {
                // Call *mywebapi*, and display its response in the page
                var request = new System.Net.Http.HttpRequestMessage();
                request.RequestUri = new Uri("http://backend/api/values/1");
                if (this.Request.Headers.ContainsKey("azds-route-as"))
                {
                    // Propagate the dev space routing header
                    request.Headers.Add("azds-route-as", this.Request.Headers["azds-route-as"] as IEnumerable<string>);
                }
                var response = await client.SendAsync(request);
                ViewData["Message"] += " and " + await response.Content.ReadAsStringAsync();
            }
            return View();
        }
 ```
 Now you can put a breakpoint in both VS Code windows and play back and forth. However, see below....
 
## PROBLEMS
Seems like dotnet 2.1 is a problem when you want to debug a service and at the same time accessing another service (or even debug both at the same time). The workaround is to install 2.0 by running ```  choco install dotnetcore-sdk --version 2.0.3 ```
At a first glance the error is because 2.1 in dev-spaces does not emit the header "azds-route-as"
