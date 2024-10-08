package xyz.crossplayproject;

import org.bukkit.Bukkit;
import org.bukkit.Material;
import org.bukkit.configuration.file.FileConfiguration;
import org.bukkit.plugin.java.JavaPlugin;
import spark.Service;

import java.util.List;
import java.util.Objects;
import java.util.Set;
import java.util.stream.Collectors;

public class CrossplayPackage extends JavaPlugin {

    private BlockHandler blockHandler;
    private EntityHandler entityHandler;
    private POSTHandler postHandler;
    private CrossChat crossChat;
    private NPCHandler npcHandler;
    private Service sparkService;
    private int sparkPort;

    @Override
    public void onEnable() {

        if (!getDataFolder().exists()) {
            getDataFolder().mkdir();
        }
        saveDefaultConfig();

        FileConfiguration config = getConfig();
        sparkPort = config.getInt("webserver.port", 4567);

        Set<Material> biomeSensitiveBlocks = loadMaterials(config.getStringList("blocks.biomeSensitive"));
        Set<Material> nonObstructingBlocks = loadMaterials(config.getStringList("blocks.nonObstructing"));
        boolean enableCulling = config.getBoolean("enableCulling", false);
        blockHandler = new BlockHandler(biomeSensitiveBlocks, nonObstructingBlocks, enableCulling);
        entityHandler = new EntityHandler();
        postHandler = new POSTHandler();
        crossChat = new CrossChat();
        npcHandler = new NPCHandler();

        setupSpark();
        crossChat.startBroadcastTask();

        getServer().getPluginManager().registerEvents(crossChat, this);

        getLogger().info("CrossplayPackage has been enabled!");

    }

    private Set<Material> loadMaterials(List<String> materialNames) {
        return materialNames.stream()
                .map(name -> {
                    try {
                        return Material.valueOf(name);
                    } catch (IllegalArgumentException e) {
                        getLogger().warning("Invalid material name in config: " + name);
                        return null;
                    }
                })
                .filter(Objects::nonNull)
                .collect(Collectors.toSet());
    }

    private void setupSpark() {
        sparkService = Service.ignite();
        sparkService.port(sparkPort);

        blockHandler.setupRoutes(sparkService);
        entityHandler.setupRoutes(sparkService);
        postHandler.setupRoutes(sparkService);
        crossChat.setupRoutes(sparkService);

        if (!Bukkit.getPluginManager().isPluginEnabled("Citizens")) {
            getLogger().warning("Citizens plugin is not installed or enabled. NPCHandler disabled.");
            npcHandler.disabledRoute(sparkService);
        } else {
            npcHandler.setupRoutes(sparkService);
        }
    }


    @Override
    public void onDisable() {

        if (sparkService != null) {
            sparkService.stop();
            sparkService.awaitStop();
        }
        getLogger().info("CrossplayPackage has been disabled!");
    }
}
