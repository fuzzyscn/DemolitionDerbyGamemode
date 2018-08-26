// Big thanks to throwarray for writing this piece of code

setInterval(function () {
	let Index = 0;

	while (Index < GetNumberOfEvents(1)) {
		let Event = GetEventAtIndex(1, Index);

		if (Event == 162) {
			let Buffer = new ArrayBuffer(6 * 8);
			let View = new DataView(Buffer);
			let GotEventData = Citizen.invokeNative("0x2902843FCD2B2D79", 1, Index, View, 6, Citizen.returnResultAnyway());
			if (GotEventData) {
				let Array = new Int32Array(Buffer);

				emit("DD:Client:PickupCollected", Array);
			}
		}


		Index++;
	}

}, 0)