{ ... }: 

{
	programs.nixvim = {
		plugins = {
			obsidian = {
				enable = true;
				settings = {
					workspaces = [
					{
						name = "vault";
						path = "/mnt/1tb/Obsidian";
					}
					];
				};
			};
		};
	};
}
