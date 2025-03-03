using Godot;
using System;

public partial class test : Node3D
{
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		Console.WriteLine("Hello World!");
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		if (Input.IsActionJustPressed("grapple_attach"))
		{
			Console.WriteLine("Hello World!");
		}
	}
}
