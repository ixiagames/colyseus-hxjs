package colyseus.client;

@:jsRequire("colyseus.js", "Client")
extern class Client {
	@:optional
	var id:String;
	var onOpen:Signal;
	var onMessage:Signal;
	var onClose:Signal;
	var onError:Signal;
	var protected:Dynamic;
	var connection:Connection;
	var rooms:Map<String, Room>;
	var connectingRooms:Map<String, Room>;
	var requestId:Float;
	var hostname:String;
	var storage:Storage;
	var roomsAvailableRequests:Map<Int, Array<RoomAvailable>>;
	function new(url:String, ?options:Dynamic):Void;
	function join(roomName:String, ?options:Dynamic):js.lib.Promise<Room>;
	function create(roomName:String, ?options:Dynamic):js.lib.Promise<Room>;
	function joinOrCreate(roomName:String, ?options:Dynamic):js.lib.Promise<Room>;
	function joinById(roomName: String, ?options: Dynamic):js.lib.Promise<Room>;
	function getAvailableRooms(roomName:String):js.lib.Promise<Array<RoomAvailable>>;
	function reconnect (roomId: String, sessionId: String):js.lib.Promise<Room>;
	function consumeSeatReservation(reservation:Dynamic):js.lib.Promise<Room>;
}

@:jsRequire("colyseus.js", "Connection")
extern class Connection {
	function new(url:Dynamic, ?querry:Dynamic):Void;
	function onOpenCallback(even:Dynamic):Void;
	function onCloseCallback(even:Dynamic):Void;
	function send(data:Dynamic):Void;
}

@:enum abstract Protocol(Int) {
	var USER_ID = 1;
	var JOIN_ROOM = 10;
	var JOIN_ERROR = 11;
	var LEAVE_ROOM = 12;
	var ROOM_DATA = 13;
	var ROOM_STATE = 14;
	var ROOM_STATE_PATCH = 15;
	var ROOM_LIST = 20;
	var BAD_REQUEST = 50;
}

@:jsRequire("colyseus.js", "Signal")
extern class Signal {
	@:selfCall function add(listener:haxe.Constraints.Function):Slot;
	function once(listener:haxe.Constraints.Function):Slot;
}

@:jsRequire("colyseus.js", "Slot")
extern class Slot {
	function execute0():Void;
	function execute1(value:Dynamic):Void;
	function execute(valueObjects:Array<Dynamic>):Void;
	var listener:haxe.Constraints.Function;
	var readonly:Dynamic;
	var once:Bool;
	var priority:Float;
	function toString():String;
	var enabled:Bool;
	var params:Array<Dynamic>;
	function remove():Void;
	function verifyListener(listener:haxe.Constraints.Function):Void;
}

@:jsRequire("colyseus.js", "StateContainer")
extern class StateContainer {
	var state:Dynamic;
	function new(state:Dynamic):Void;
	function set(newState:Dynamic):Void;
	function registerPlaceholder(placeholder:String, matcher:js.lib.RegExp):Void;
	function listen(segments:haxe.extern.EitherType<String, haxe.Constraints.Function>, ?callback:haxe.Constraints.Function):Void;
	function removeListener(listener:Dynamic):Void;
	function removeAllListeners():Void;
}

@:jsRequire("colyseus.js", "Room")
extern class Room extends StateContainer {
	var id:String;
	var sessionId:String;
	var name:String;
	var options:Dynamic;
	var clock:Clock;
	var remoteClock:Clock;
	var onStateChange:Signal;
	var onMessage:Signal;
	var onError:Signal;
	var onLeave:Signal;
	var connection:Connection;
	function new(name:String, ?options:Dynamic):Void;
	function connect(connection:Connection):Void;
	function leave():Void;
	function send(data:Dynamic):Void;
	function onMessageCallback(event:Dynamic):Void;
	function setState(encodedState:Dynamic, ?remoteCurrentTime:Float, ?remoteElapsedTime:Float):Void;
	function patch(binaryPatch:Dynamic):Void;
}

typedef RoomAvailable = {
	var roomId:String;
	var clients:Float;
	var maxClients:Float;
	@:optional var metadata:Dynamic;
};

typedef Clock = Dynamic;
typedef Storage = Dynamic;
