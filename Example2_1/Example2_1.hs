module Main where
import qualified Graphics.UI.GLFW as GLFW
import Control.Monad(unless, when)
import Graphics.Rendering.OpenGL
import System.Exit

numPoints :: Int
numPoints = 5000

data Vec2 = Vec2 Double Double

init :: IO ()
init = do
  vertices <- return [(Vec2 -1.0 -1.0, Vec2 0.0 1.0, Vec2 1.0 -1.0)]
  someRandomPoint <- return $ Vec2 0.25 0.50
  
  randomPoint <- 

main :: IO ()
main = do
  glfwInit <- GLFW.init
  _ <- GLFW.setErrorCallback $ Just errorHandler
  if (glfwInit == False) then
    GLFW.terminate
    else do
    maybeWindow <- GLFW.createWindow 640 480 "My title" Nothing Nothing
    case maybeWindow of
      Just window -> do
        GLFW.makeContextCurrent $ Just window
        GLFW.setKeyCallback window $ Just keyCallback
        mainLoop window
        GLFW.destroyWindow window
        GLFW.terminate
        exitSuccess
      Nothing -> do
        GLFW.terminate
        exitFailure

mainLoop :: GLFW.Window -> IO ()
mainLoop w = do
  (width, height) <- GLFW.getFramebufferSize w
  let ratio = fromIntegral width / fromIntegral height
  viewport $= (Position 0 0, Size (fromIntegral width) (fromIntegral height))
  Just time <- GLFW.getTime
  clear [ColorBuffer]
  matrixMode $= Projection
  loadIdentity
  ortho (negate ratio) ratio (negate 1.0) 1.0 1.0 (negate 1.0)
  matrixMode $= Modelview 0
  loadIdentity
  rotate ((realToFrac time) * 50) $ (Vector3 0 0 1 :: Vector3 GLdouble)
  renderPrimitive Triangles $ do
    color  (Color3 1 0 0 :: Color3 GLdouble)
    vertex (Vertex3 (negate 0.6) (negate 0.4) 0 :: Vertex3 GLdouble)
    color  (Color3 0 1 0 :: Color3 GLdouble)
    vertex (Vertex3 0.6 (negate 0.4) 0 :: Vertex3 GLdouble)
    color  (Color3 0 0 1 :: Color3 GLdouble)
    vertex (Vertex3 0 0.6 0 :: Vertex3 GLdouble)
  GLFW.swapBuffers w
  GLFW.pollEvents
  shouldClose <- GLFW.windowShouldClose w
  unless (shouldClose) $ mainLoop w

errorHandler :: GLFW.Error -> String -> IO ()
errorHandler glfwError str = putStrLn $ ((show glfwError) ++ " " ++ str)

keyCallback :: GLFW.KeyCallback
keyCallback window key scancode action mods = when (key == GLFW.Key'Escape && action == GLFW.KeyState'Pressed) $
  GLFW.setWindowShouldClose window True
  -- 
