#Область СлужебныйПрограммныйИнтерфейс

Процедура УдалитьЗапись(Метрика) Экспорт
	
	МенеджерЗаписи = РегистрыСведений.пэмСостояниеМетрик.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Метрика = Метрика.Ссылка;
	МенеджерЗаписи.Удалить();

КонецПроцедуры

#КонецОбласти