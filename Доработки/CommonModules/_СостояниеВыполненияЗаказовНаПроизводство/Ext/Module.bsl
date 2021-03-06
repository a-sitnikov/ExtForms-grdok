﻿
Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	Форма.Элементы.СостояниеЗаказов.Подвал = Истина;
	
	Форма.Элементы.СостояниеЗаказовПоЗаказу.ШрифтПодвала  = Новый Шрифт(,, Истина);
	Форма.Элементы.СостояниеЗаказовВыполнено.ШрифтПодвала = Новый Шрифт(,, Истина);
	Форма.Элементы.СостояниеЗаказовОсталось.ШрифтПодвала  = Новый Шрифт(,, Истина);
	
	Форма.Элементы.СостояниеЗаказовПоЗаказу.ГоризонтальноеПоложениеВПодвале  = ГоризонтальноеПоложениеЭлемента.Право;
	Форма.Элементы.СостояниеЗаказовВыполнено.ГоризонтальноеПоложениеВПодвале = ГоризонтальноеПоложениеЭлемента.Право;
	Форма.Элементы.СостояниеЗаказовОсталось.ГоризонтальноеПоложениеВПодвале  = ГоризонтальноеПоложениеЭлемента.Право;
	
КонецПроцедуры

Процедура ПересчитатьИтоги(Форма) Экспорт
	
	Итоги = Новый Структура;
	Итоги.Вставить("ПоЗаказу",  0);
	Итоги.Вставить("Выполнено", 0);
	Итоги.Вставить("Осталось",  0);
	
	Для каждого Строка1 из Форма.СостояниеЗаказов.ПолучитьЭлементы() Цикл
		
		Для каждого Строка2 из Строка1.ПолучитьЭлементы() Цикл
			
			Для каждого КлючИЗначение из Итоги Цикл
				Итоги[КлючИЗначение.Ключ] = КлючИЗначение.Значение + Строка2[КлючИЗначение.Ключ];
			КонецЦикла;	
			
		КонецЦикла;	
		
	КонецЦикла;	
	
	Для каждого КлючИЗначение из Итоги Цикл
		Форма.Элементы["СостояниеЗаказов" + КлючИЗначение.Ключ].ТекстПодвала = КлючИЗначение.Значение;
	КонецЦикла;
	
КонецПроцедуры	