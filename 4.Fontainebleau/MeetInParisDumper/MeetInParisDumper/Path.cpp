
#include "Path.h"
#include "StringHelper.h"

namespace Path 
{
	const WCHAR* GetFileNameW(const WCHAR* filePath)
	{
		
		//获取最大索引(字符串长度-1)
		SInteger index = Strings::StringLengthW(filePath) - 1;

		//从后向前扫描 扫描反斜杠
		while (index != -1)
		{
			if (filePath[index] == '\\')
			{
				//扫描成功 指向文件名地址
				return filePath + index + 1;
			}
			index--;	 //索引自减
		}
		//扫描不到
		return filePath;
	}

	void GetDirectoryPathW(WCHAR* filePath, BOOL slash) 
	{
		//获取最大索引(字符串长度-1)
		SInteger index = Strings::StringLengthW(filePath) - 1;

		//从后向前扫描 扫描反斜杠
		while (index != -1)
		{
			if (filePath[index] == '\\')
			{
				//扫描成功
				//保留斜杠则索引自增略过斜杠
				if (slash)
				{
					index += 1;
				}
				// 使用\0填充截断
				filePath[index] = '\0';
				return;
			}
			index--;	 //索引自减
		}
	}

	void GetDirectoryPathW(WCHAR* filePath, WCHAR* buffer, BOOL slash)
	{
		//获取最大索引(字符串长度-1)
		SInteger index = Strings::StringLengthW(filePath) - 1;

		//从后向前扫描
		while (index != -1)
		{
			if (filePath[index] == '\\')
			{
				//扫描成功
				//保留斜杠则索引自增略过斜杠
				if (slash)
				{
					index += 1;
				}
				Strings::StringCopyW(buffer, filePath, index, TRUE);		//复制到目标字符串
				return;
			}
			index--;	 //索引自减
		}
		Strings::StringCopyW(buffer, filePath);		//扫描不到 复制到目标字符串
	}

	const WCHAR* GetFileExtension(const WCHAR* filePath)
	{
		//获取最大索引(字符串长度-1)
		SInteger index = Strings::StringLengthW(filePath) - 1;

		//从后向前扫描 扫描反斜杠
		while (index != -1) 
		{
			if (filePath[index] == '.')
			{
				//扫描成功 指向文件扩展名地址
				return filePath + index;
			}
			index--;	 //索引自减
		}
		//扫描不到
		return filePath;
	}
}
