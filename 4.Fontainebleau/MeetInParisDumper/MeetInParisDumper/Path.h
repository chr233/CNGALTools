
#include <Windows.h>
#include "BaseType.h"
namespace Path 
{
	/// <summary>
	/// 获取绝对路径中的文件名 
	/// (路径必须为\0结束)
	/// </summary>
	/// <param name="filePath">绝对路径</param>
	/// <returns></returns>
	const WCHAR* GetFileNameW(const WCHAR* filePath);

	/// <summary>
	/// 获取绝对路径中的文件夹路径
	/// (路径必须为\0结束 直接在原字符串修改)
	/// </summary>
	/// <param name="filePath">文件路径</param>
	/// <param name="slash">TRUE为含反斜杠 FALSE不含反斜杠</param>
	void GetDirectoryPathW(WCHAR* filePath, BOOL slash);
	
	/// <summary>
	/// 获取绝对路径中的文件夹路径
	/// (目标缓存必须可以容纳字符串内容)
	/// </summary>
	/// <param name="filePath">文件路径</param>
	/// <param name="buffer">目标缓存</param>
	/// <param name="slash">TRUE为含反斜杠 FALSE不含反斜杠</param>
	void GetDirectoryPathW(WCHAR* filePath, WCHAR* buffer, BOOL slash);

	/// <summary>
	/// 获取文件扩展名
	/// (路径必须为\0结束)
	/// </summary>
	/// <param name="filePath">路径</param>
	/// <returns></returns>
	const WCHAR* GetFileExtension(const WCHAR* filePath);


}