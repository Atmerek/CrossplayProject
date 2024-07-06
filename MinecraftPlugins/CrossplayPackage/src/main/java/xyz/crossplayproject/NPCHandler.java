package xyz.crossplayproject;

import com.google.gson.Gson;
import net.citizensnpcs.api.CitizensAPI;
import net.citizensnpcs.api.npc.MemoryNPCDataStore;
import net.citizensnpcs.api.npc.NPC;
import net.citizensnpcs.trait.Gravity;
import net.citizensnpcs.trait.SkinTrait;
import org.bukkit.Bukkit;
import org.bukkit.Location;
import org.bukkit.World;
import org.bukkit.entity.EntityType;
import org.bukkit.plugin.java.JavaPlugin;
import org.bukkit.scheduler.BukkitRunnable;
import org.bukkit.util.Vector;
import spark.Request;
import spark.Response;

import java.util.HashMap;
import java.util.Map;
import java.util.logging.Level;

public class NPCHandler {

    private static final Map<String, NPC> npcs = new HashMap<>();
    private static final Map<String, BukkitRunnable> currentTasks = new HashMap<>();

    public void setupRoutes(spark.Service spark) {
        spark.post("/npc", NPCHandler::handleDataRequest);
    }

    private static String handleDataRequest(Request req, Response res) {
        try {
            Gson gson = new Gson();
            PlayerUpdate player = gson.fromJson(req.body(), PlayerUpdate.class);
            new BukkitRunnable() {
                public void run() {
                    player.execute();
                }
            }.runTask(JavaPlugin.getPlugin(CrossplayPackage.class));

            return "OK";
        } catch (Exception e) {
            JavaPlugin.getPlugin(CrossplayPackage.class).getLogger().log(Level.SEVERE, "Error in NPCHandler", e);
            res.status(500);
            return "Internal Server Error";
        }
    }

    static class PlayerUpdate {
        private final String user;
        private final double x, y, z;
        private final float yaw, pitch;
        private final boolean disconnect;

        public PlayerUpdate(String user, double x, double y, double z, float yaw, float pitch, boolean disconnect) {
            this.user = user;
            this.x = x;
            this.y = y;
            this.z = z;
            this.yaw = yaw;
            this.pitch = pitch;
            this.disconnect = disconnect;
        }

        public void execute() {
            if (disconnect) {
                despawnNPC(user);
                return;
            }

            World world = Bukkit.getWorlds().get(0);
            if (world == null) {
                Bukkit.getLogger().warning("World 0 not found!");
                return;
            }

            Location targetLocation = new Location(world, x + 0.5, y, z + 0.5, yaw, pitch);
            NPC npc = npcs.get(user);
            if (npc != null && npc.isSpawned()) {
                moveNPC(user, npc, targetLocation);
            } else {
                spawnNPC(user, targetLocation);
            }
        }

        private static final double SPEED = 0.3;

        private void moveNPC(String user, NPC npc, Location targetLocation) {
            if (currentTasks.containsKey(user)) {
                currentTasks.get(user).cancel();
            }

            Location currentLocation = npc.getEntity().getLocation();
            Vector direction = targetLocation.toVector().subtract(currentLocation.toVector()).normalize();
            double distance = currentLocation.distance(targetLocation);
            double ticks = distance / SPEED;

            BukkitRunnable task = new BukkitRunnable() {
                double progress = 0;

                @Override
                public void run() {
                    if (progress >= ticks) {
                        npc.teleport(targetLocation, org.bukkit.event.player.PlayerTeleportEvent.TeleportCause.PLUGIN);
                        cancel();
                        currentTasks.remove(user);
                        return;
                    }

                    Vector nextPosition = currentLocation.toVector().add(direction.clone().multiply(SPEED * progress));
                    Location nextLocation = new Location(
                            currentLocation.getWorld(),
                            nextPosition.getX(),
                            nextPosition.getY(),
                            nextPosition.getZ(),
                            targetLocation.getYaw(),
                            targetLocation.getPitch()
                    );

                    npc.teleport(nextLocation, org.bukkit.event.player.PlayerTeleportEvent.TeleportCause.PLUGIN);
                    progress += 1;
                }
            };

            task.runTaskTimer(JavaPlugin.getPlugin(CrossplayPackage.class), 0L, 1L);
            currentTasks.put(user, task);
        }


        private void spawnNPC(String user, Location targetLocation) {
            NPC npc = CitizensAPI.createAnonymousNPCRegistry(new MemoryNPCDataStore()).createNPC(EntityType.PLAYER, user);
            SkinTrait skinTrait = npc.getOrAddTrait(SkinTrait.class);
            String uniqueId = "44513fe2";
            String signature = "h4HqPM8t49wNC0vw1I5vrwAHAlMIFBJkISjFGqU3fI5oig2QIpo3NIsQrK93vBsMhLVT+p7l5+BFvm3ZyMi7DfYcswgoVMkKlu+Abn6XPH8TruYoVs6GGw0sJ6xR6mN8TTnL0dPMkNFyoyk5S4P2cKU2KkG69ajHDD5iie/sEm+VrVgAb6iBpaFIhVptlqcca488dKp6y5FvywP+WIOcgcH99tcuOus1GiE8VXzu21+hGRwAa2Gv69uTLJmqzSpk9tS+2wLlYqETXRLDSC/fErBTWGYHh34+rkmXbABlo7jLu1AWgoO4tnwWQ1aIwyb1eoaaOUDuidQWrQsjr2bb7+cSQDHNdP4OXY8dzOiUwRxLBRmBP7cHHZuvxDTiy0PcLbzr+mcX033s83rhKCH4lYgiA+RwJIrCLSn+illWfWbws9me342ScFqd5uSCuiIHVRPB1Zl8O3XQJT4rXtBm7MLxahihZsPsrYRT7bZ+Qqn6XTNodh3yBHpaBQsgCQQmqdsg+xSGM/QfyFPaEqP9b47nmALNqjQXGUagi+TDFg1CUJ1Loc14tzqwwZdUHeyPAomv2ZSiyK7c/25H23Yu8bnnoFNIfiWPQxUXg6ROssDGa1xuFjOpyRiio0yOYZRNYbQYT53BCc5ykjl1gqLK/BHz47zziX7bLQ5F/UUiMxc=";
            String texture = "ewogICJ0aW1lc3RhbXAiIDogMTY0MDQ5NTY3NTk0NSwKICAicHJvZmlsZUlkIiA6ICIzOWEzOTMzZWE4MjU0OGU3ODQwNzQ1YzBjNGY3MjU2ZCIsCiAgInByb2ZpbGVOYW1lIiA6ICJkZW1pbmVjcmFmdGVybG9sIiwKICAic2lnbmF0dXJlUmVxdWlyZWQiIDogdHJ1ZSwKICAidGV4dHVyZXMiIDogewogICAgIlNLSU4iIDogewogICAgICAidXJsIiA6ICJodHRwOi8vdGV4dHVyZXMubWluZWNyYWZ0Lm5ldC90ZXh0dXJlL2FmYjFiMzM2MjQwNDk1NjBlMjc2YWEwYTY2M2FiMmI3MDI2Yzk0MzE5NTIwOGFhYmY5NDljODU1MTlkZTJjYTIiCiAgICB9CiAgfQp9";
            skinTrait.setSkinPersistent(uniqueId, signature, texture);

            Gravity gravityTrait = npc.getTrait(Gravity.class);
            gravityTrait.gravitate(true);

            npc.spawn(targetLocation);
            npcs.put(user, npc);
            Bukkit.broadcastMessage("§f§7[RB]§e " + user + " joined the game");
        }

        private void despawnNPC(String user) {
            NPC npc = npcs.get(user);
            if (npc != null && npc.isSpawned()) {
                if (currentTasks.containsKey(user)) {
                    currentTasks.get(user).cancel();
                    currentTasks.remove(user);
                }
                npc.despawn();
                npcs.remove(user);
                Bukkit.broadcastMessage("§f§7[RB]§e " + user + " left the game");
            }
        }
    }
}
