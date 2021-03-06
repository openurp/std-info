// num:身份证号码，birthday:出生日期，sex:性别(男-1,女-2)
function IsCardNo(num, birthday, sex) {
	num = num.toUpperCase(); 
    //身份证号码为15位或者18位，15位时全为数字，18位前17位为数字，最后一位是校验位，可能为数字或字符X。  
	if (!(/(^\d{15}$)|(^\d{17}([0-9]|X)$)/.test(num))) {
		alert('输入的身份证号长度不对，或者号码不符合规定！\n15位号码应全为数字，18位号码末位可以为数字或X。');
		return false;
	}
	//校验位按照ISO 7064:1983.MOD 11-2的规定生成，X可以认为是数字10。
	//下面分别分析出生日期和校验位
	var len, re;
	len = num.length;
	
	if (len == 15) {
		re = new RegExp(/^(\d{6})(\d{2})(\d{2})(\d{2})(\d{3})$/);
		var arrSplit = num.match(re);

		//检查生日日期是否正确
		var dtmBirth;
		if(document.all){
			dtmBirth = new Date(birthday.split('-').join('/'));
		}else{
			dtmBirth = new Date(birthday);
		}
		var bGoodDay;
		bGoodDay = (dtmBirth.getYear() == Number(arrSplit[2])) && ((dtmBirth.getMonth() + 1) == Number(arrSplit[3])) && (dtmBirth.getDate() == Number(arrSplit[4]));
		if (!bGoodDay) {
			alert('输入的身份证号里出生日期不对！');
			return false;
		} else {
			// 验证性别
			//var sexCode = num.substr(14,1);
			//if (sexCode == "0" || sexCode == "2" || sexCode == "4" || sexCode == "6" || sexCode == "8") {
			//	if (sex == 1) {
			//		alert('输入的身份证号码与性别不符合!');
			//		return false;
			//	}
			//} else if (sexCode == "1" || sexCode == "3" || sexCode == "5" || sexCode == "7" || sexCode == "9") {
			//	if (sex == 2) {
			//		alert('输入的身份证号码与性别不符合!');
			//		return false;
			//	}
			//}
			
			//将15位身份证转成18位
			//校验位按照ISO 7064:1983.MOD 11-2的规定生成，X可以认为是数字10。
			var arrInt = new Array(7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2);
			var arrCh = new Array('1', '0', 'X', '9', '8', '7', '6', '5', '4', '3', '2');
			var nTemp = 0, i;  
			num = num.substr(0, 6) + '19' + num.substr(6, num.length - 6);
			for(i = 0; i < 17; i ++) {
				nTemp += num.substr(i, 1) * arrInt[i];
			}
			num += arrCh[nTemp % 11];  
			return true;  
		}  
	}
	
	if (len == 18) {
		re = new RegExp(/^(\d{6})(\d{4})(\d{2})(\d{2})(\d{3})([0-9]|X)$/);
		var arrSplit = num.match(re);

		//检查生日日期是否正确
		if(document.all){
			var dtmBirth = new Date(birthday.split('-').join('/'));
		}else{
			var dtmBirth = new Date(birthday);
		}
		var bGoodDay;
		bGoodDay = (dtmBirth.getFullYear() == Number(arrSplit[2])) && ((dtmBirth.getMonth() + 1) == Number(arrSplit[3])) && (dtmBirth.getDate() == Number(arrSplit[4]));
		if (!bGoodDay) {
			alert('输入的身份证号里出生日期不对！');
			return false;
		} else {
			// 验证性别
			//var sexCode = num.substr(17,1);
			//if (sexCode == "0" || sexCode == "2" || sexCode == "4" || sexCode == "6" || sexCode == "8") {
			//	if (sex == 1) {
			//		alert('输入的身份证号码与性别不符合!');
			//		return false;
			//	}
			//} else if (sexCode == "1" || sexCode == "3" || sexCode == "5" || sexCode == "7" || sexCode == "9") {
			//	if (sex == 2) {
			//		alert('输入的身份证号码与性别不符合!');
			//		return false;
			//	}
			//}
			
			//检验18位身份证的校验码是否正确。
			//校验位按照ISO 7064:1983.MOD 11-2的规定生成，X可以认为是数字10。
			var valnum;
			var arrInt = new Array(7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2);
			var arrCh = new Array('1', '0', 'X', '9', '8', '7', '6', '5', '4', '3', '2');
			var nTemp = 0, i;
			for(i = 0; i < 17; i ++) {
				nTemp += num.substr(i, 1) * arrInt[i];
			}
			valnum = arrCh[nTemp % 11];
			if (valnum != num.substr(17, 1)) {
				//alert('18位身份证的校验码不正确！应该为：' + valnum);
				alert('18位身份证的校验码不正确！');
				return false;
			}
			return true;
		}
	}
	alert('身份证号码验证失败!');
	return false; 
} 