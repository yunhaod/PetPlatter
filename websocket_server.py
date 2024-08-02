async def echo(websocket, path):
    connected_clients.add(websocket)
    try:
        async for message in websocket:
            print(f"Received message: {message}")
            for client in connected_clients:
                if client != websocket:
                    await client.send(f"{message}")
            print(f"Sent message: {message}")
    except websockets.ConnectionClosed:
        print("Connection closed")
    finally:
    connected_clients.remove(websocket)
start_server = websockets.serve(echo, "0.0.0.0", 8765)

asyncio.get_event_loop().run_until_complete(start_server)
asyncio.get_event_loop().run_forever()

