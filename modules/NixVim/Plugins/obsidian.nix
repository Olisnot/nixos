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
						path = "/home/oliver/Obsidian/";
					}
					];
				};
			};
		};
	};
}
