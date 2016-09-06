package wg.caller.command
{
	public interface ICommand
	{
		function exec(param: Object): void;
	}
}