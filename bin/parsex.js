(function () { "use strict";
var $estr = function() { return js.Boot.__string_rec(this,''); };
function $extend(from, fields) {
	function inherit() {}; inherit.prototype = from; var proto = new inherit();
	for (var name in fields) proto[name] = fields[name];
	return proto;
}
var EReg = function(r,opt) {
	opt = opt.split("u").join("");
	this.r = new RegExp(r,opt);
};
EReg.__name__ = ["EReg"];
EReg.prototype = {
	matchedPos: function() {
		if(this.r.m == null) throw "No string matched";
		return { pos : this.r.m.index, len : this.r.m[0].length};
	}
	,match: function(s) {
		if(this.r.global) this.r.lastIndex = 0;
		this.r.m = this.r.exec(s);
		this.r.s = s;
		return this.r.m != null;
	}
	,__class__: EReg
}
var HxOverrides = function() { }
HxOverrides.__name__ = ["HxOverrides"];
HxOverrides.cca = function(s,index) {
	var x = s.charCodeAt(index);
	if(x != x) return undefined;
	return x;
}
HxOverrides.substr = function(s,pos,len) {
	if(pos != null && pos != 0 && len != null && len < 0) return "";
	if(len == null) len = s.length;
	if(pos < 0) {
		pos = s.length + pos;
		if(pos < 0) pos = 0;
	} else if(len < 0) len = s.length + len - pos;
	return s.substr(pos,len);
}
HxOverrides.iter = function(a) {
	return { cur : 0, arr : a, hasNext : function() {
		return this.cur < this.arr.length;
	}, next : function() {
		return this.arr[this.cur++];
	}};
}
var Lambda = function() { }
Lambda.__name__ = ["Lambda"];
Lambda.array = function(it) {
	var a = new Array();
	var $it0 = $iterator(it)();
	while( $it0.hasNext() ) {
		var i = $it0.next();
		a.push(i);
	}
	return a;
}
var PrimitiveType = { __ename__ : true, __constructs__ : ["Number","FloatNumber"] }
PrimitiveType.Number = function(x) { var $x = ["Number",0,x]; $x.__enum__ = PrimitiveType; $x.toString = $estr; return $x; }
PrimitiveType.FloatNumber = function(x) { var $x = ["FloatNumber",1,x]; $x.__enum__ = PrimitiveType; $x.toString = $estr; return $x; }
var RExpression = { __ename__ : true, __constructs__ : ["Primitive","Ident","LambdaExpr","Apply"] }
RExpression.Primitive = function(p) { var $x = ["Primitive",0,p]; $x.__enum__ = RExpression; $x.toString = $estr; return $x; }
RExpression.Ident = function(id) { var $x = ["Ident",1,id]; $x.__enum__ = RExpression; $x.toString = $estr; return $x; }
RExpression.LambdaExpr = function(param,expr) { var $x = ["LambdaExpr",2,param,expr]; $x.__enum__ = RExpression; $x.toString = $estr; return $x; }
RExpression.Apply = function(fun,param) { var $x = ["Apply",3,fun,param]; $x.__enum__ = RExpression; $x.toString = $estr; return $x; }
var com = {}
com.mindrocks = {}
com.mindrocks.text = {}
com.mindrocks.text.ParseResult = { __ename__ : true, __constructs__ : ["Success","Failure"] }
com.mindrocks.text.ParseResult.Success = function(match,rest) { var $x = ["Success",0,match,rest]; $x.__enum__ = com.mindrocks.text.ParseResult; $x.toString = $estr; return $x; }
com.mindrocks.text.ParseResult.Failure = function(errorStack,rest,isError) { var $x = ["Failure",1,errorStack,rest,isError]; $x.__enum__ = com.mindrocks.text.ParseResult; $x.toString = $estr; return $x; }
com.mindrocks.text.FailureObj = function() { }
com.mindrocks.text.FailureObj.__name__ = ["com","mindrocks","text","FailureObj"];
com.mindrocks.text.FailureObj.newStack = function(failure) {
	var newStack = com.mindrocks.functional.Nil._nil;
	return new com.mindrocks.functional.List(failure,newStack);
}
com.mindrocks.text.FailureObj.errorAt = function(msg,pos) {
	return { msg : msg, pos : pos.offset};
}
com.mindrocks.text.FailureObj.report = function(stack,msg) {
	return new com.mindrocks.functional.List(msg,stack);
}
com.mindrocks.functional = {}
com.mindrocks.functional.List = function(v,t) {
	this._headV = v;
	this._tailV = t;
};
com.mindrocks.functional.List.__name__ = ["com","mindrocks","functional","List"];
com.mindrocks.functional.List.nil = function() {
	return com.mindrocks.functional.Nil._nil;
}
com.mindrocks.functional.List.cons = function(t,v) {
	return new com.mindrocks.functional.List(v,t);
}
com.mindrocks.functional.List.contains = function(l,v) {
	while(!l.isEmpty()) {
		if(l.get_head() == v) return true;
		l = l.get_tail();
	}
	return false;
}
com.mindrocks.functional.List.filter = function(l,p) {
	if(l.isEmpty()) return com.mindrocks.functional.Nil._nil; else {
		var v = l.get_head();
		var tail = com.mindrocks.functional.List.filter(l.get_tail(),p);
		if(p(v)) return new com.mindrocks.functional.List(v,tail); else return tail;
	}
}
com.mindrocks.functional.List.each = function(l,p) {
	if(l.isEmpty()) com.mindrocks.functional.Nil._nil; else {
		p(l.get_head());
		var l1 = l.get_tail();
	}
}
com.mindrocks.functional.List.map = function(l,p) {
	if(l.isEmpty()) return new com.mindrocks.functional.Nil(); else return new com.mindrocks.functional.List(p(l.get_head()),com.mindrocks.functional.List.map(l.get_tail(),p));
}
com.mindrocks.functional.List.last = function(l) {
	var r = null;
	while(true) if(js.Boot.__instanceof(l,com.mindrocks.functional.Nil)) {
		if(r == null) throw "last called on Nil"; else return r.get_head();
	} else {
		r = l;
		l = l.get_tail();
	}
	return null;
}
com.mindrocks.functional.List.prototype = {
	isEmpty: function() {
		return false;
	}
	,get_tail: function() {
		return this._tailV;
	}
	,get_head: function() {
		return this._headV;
	}
	,__class__: com.mindrocks.functional.List
}
com.mindrocks.functional.Nil = function() {
	com.mindrocks.functional.List.call(this,null,null);
};
com.mindrocks.functional.Nil.__name__ = ["com","mindrocks","functional","Nil"];
com.mindrocks.functional.Nil.__super__ = com.mindrocks.functional.List;
com.mindrocks.functional.Nil.prototype = $extend(com.mindrocks.functional.List.prototype,{
	get_tail: function() {
		throw "Cannot access tail of Nil";
		return null;
	}
	,get_head: function() {
		throw "Cannot access head of Nil";
		return null;
	}
	,isEmpty: function() {
		return true;
	}
	,__class__: com.mindrocks.functional.Nil
});
var Parsers = function() { }
Parsers.__name__ = ["Parsers"];
Parsers.mkLR = function(seed,rule,head) {
	return { seed : seed, rule : rule, head : head};
}
Parsers.mkHead = function(p) {
	return { headParser : p, involvedSet : com.mindrocks.functional.Nil._nil, evalSet : com.mindrocks.functional.Nil._nil};
}
Parsers.getPos = function(lr) {
	return (function($this) {
		var $r;
		var $e = (lr.seed);
		switch( $e[1] ) {
		case 0:
			var lr_fseed_eSuccess_1 = $e[3];
			$r = lr_fseed_eSuccess_1;
			break;
		case 1:
			var lr_fseed_eFailure_1 = $e[3];
			$r = lr_fseed_eFailure_1;
			break;
		}
		return $r;
	}(this));
}
Parsers.getHead = function(hd) {
	var r = hd.headParser;
	return r;
}
Parsers.parserUid = function() {
	return ++Parsers._parserUid;
}
Parsers.lrAnswer = function(p,genKey,input,growable) {
	var $e = (growable.head);
	switch( $e[1] ) {
	case 0:
		throw "lrAnswer with no head!!";
		break;
	case 1:
		var growable_fhead_eSome_0 = $e[2];
		if(Parsers.getHead(growable_fhead_eSome_0) != p) {
			var r = growable.seed;
			return r;
		} else {
			com.mindrocks.text.MemoObj.updateCacheAndGet(input,genKey,com.mindrocks.text.MemoEntry.MemoParsed(growable.seed));
			switch( (growable.seed)[1] ) {
			case 1:
				var r = growable.seed;
				return r;
			case 0:
				return Parsers.grow(p,genKey,input,growable_fhead_eSome_0);
			}
		}
		break;
	}
}
Parsers.recall = function(p,genKey,input) {
	var cached = com.mindrocks.text.MemoObj.getFromCache(input,genKey);
	var _g = com.mindrocks.text.MemoObj.getRecursionHead(input);
	var $e = (_g);
	switch( $e[1] ) {
	case 0:
		return cached;
	case 1:
		var _g_eSome_0 = $e[2];
		if(cached == com.mindrocks.functional.Option.None && !com.mindrocks.functional.List.contains(new com.mindrocks.functional.List(_g_eSome_0.headParser,_g_eSome_0.involvedSet),p)) return com.mindrocks.functional.Option.Some(com.mindrocks.text.MemoEntry.MemoParsed(com.mindrocks.text.ParseResult.Failure(com.mindrocks.text.FailureObj.newStack({ msg : "dummy ", pos : input.offset}),input,false)));
		if(com.mindrocks.functional.List.contains(_g_eSome_0.evalSet,p)) {
			_g_eSome_0.evalSet = com.mindrocks.functional.List.filter(_g_eSome_0.evalSet,function(x) {
				return x != p;
			});
			var memo = com.mindrocks.text.MemoEntry.MemoParsed(p(input));
			com.mindrocks.text.MemoObj.updateCacheAndGet(input,genKey,memo);
			cached = com.mindrocks.functional.Option.Some(memo);
		}
		return cached;
	}
}
Parsers.setupLR = function(p,input,recDetect) {
	if(recDetect.head == com.mindrocks.functional.Option.None) recDetect.head = com.mindrocks.functional.Option.Some(Parsers.mkHead(p));
	var stack = input.memo.lrStack;
	var h = com.mindrocks.functional.Functionnal.get(recDetect.head);
	while(stack.get_head().rule != p) {
		var head = stack.get_head();
		head.head = recDetect.head;
		h.involvedSet = new com.mindrocks.functional.List(head.rule,h.involvedSet);
		stack = stack.get_tail();
	}
}
Parsers.grow = function(p,genKey,rest,head) {
	rest.memo.recursionHeads.set(rest.offset + "",head);
	var oldRes = (function($this) {
		var $r;
		var _g = com.mindrocks.functional.Functionnal.get(com.mindrocks.text.MemoObj.getFromCache(rest,genKey));
		$r = (function($this) {
			var $r;
			var $e = (_g);
			switch( $e[1] ) {
			case 0:
				var _g_eMemoParsed_0 = $e[2];
				$r = _g_eMemoParsed_0;
				break;
			default:
				$r = (function($this) {
					var $r;
					throw "impossible match";
					return $r;
				}($this));
			}
			return $r;
		}($this));
		return $r;
	}(this));
	head.evalSet = head.involvedSet;
	var res = p(rest);
	var $e = (res);
	switch( $e[1] ) {
	case 0:
		if(com.mindrocks.text.ResultObj.posFromResult(oldRes).offset < com.mindrocks.text.ResultObj.posFromResult(res).offset) {
			com.mindrocks.text.MemoObj.updateCacheAndGet(rest,genKey,com.mindrocks.text.MemoEntry.MemoParsed(res));
			return Parsers.grow(p,genKey,rest,head);
		} else {
			rest.memo.recursionHeads.remove(rest.offset + "");
			var _g1 = com.mindrocks.functional.Functionnal.get(com.mindrocks.text.MemoObj.getFromCache(rest,genKey));
			var $e = (_g1);
			switch( $e[1] ) {
			case 0:
				var _g1_eMemoParsed_0 = $e[2];
				var r = _g1_eMemoParsed_0;
				return r;
			default:
				throw "impossible match";
			}
		}
		break;
	case 1:
		var res_eFailure_2 = $e[4];
		if(res_eFailure_2) {
			com.mindrocks.text.MemoObj.updateCacheAndGet(rest,genKey,com.mindrocks.text.MemoEntry.MemoParsed(res));
			rest.memo.recursionHeads.remove(rest.offset + "");
			return res;
		} else {
			rest.memo.recursionHeads.remove(rest.offset + "");
			var r = oldRes;
			return r;
		}
		break;
	}
}
Parsers.memo = function(_p) {
	return (function($this) {
		var $r;
		var value = null;
		var computationRequested = false;
		$r = function() {
			if(!computationRequested) {
				computationRequested = true;
				value = (function($this) {
					var $r;
					var uid = Parsers.parserUid();
					var genKey = function(pos) {
						return uid + "@" + pos;
					};
					$r = function(input) {
						var _g = Parsers.recall(_p(),genKey,input);
						var $e = (_g);
						switch( $e[1] ) {
						case 0:
							var base = Parsers.mkLR(com.mindrocks.text.ParseResult.Failure(com.mindrocks.text.FailureObj.newStack({ msg : "Base Failure", pos : input.offset}),input,false),_p(),com.mindrocks.functional.Option.None);
							input.memo.lrStack = new com.mindrocks.functional.List(base,input.memo.lrStack);
							com.mindrocks.text.MemoObj.updateCacheAndGet(input,genKey,com.mindrocks.text.MemoEntry.MemoLR(base));
							var res = (_p())(input);
							input.memo.lrStack = input.memo.lrStack.get_tail();
							switch( (base.head)[1] ) {
							case 0:
								com.mindrocks.text.MemoObj.updateCacheAndGet(input,genKey,com.mindrocks.text.MemoEntry.MemoParsed(res));
								return res;
							case 1:
								base.seed = res;
								return Parsers.lrAnswer(_p(),genKey,input,base);
							}
							break;
						case 1:
							var _g_eSome_0 = $e[2];
							var $e = (_g_eSome_0);
							switch( $e[1] ) {
							case 1:
								var mEntry_eMemoLR_0 = $e[2];
								Parsers.setupLR(_p(),input,mEntry_eMemoLR_0);
								var r = mEntry_eMemoLR_0.seed;
								return r;
							case 0:
								var mEntry_eMemoParsed_0 = $e[2];
								var r = mEntry_eMemoParsed_0;
								return r;
							}
							break;
						}
					};
					return $r;
				}(this));
			}
			return value;
		};
		return $r;
	}(this));
}
Parsers.fail = function(error,isError) {
	return (function($this) {
		var $r;
		var value = null;
		var computationRequested = false;
		$r = function() {
			if(!computationRequested) {
				computationRequested = true;
				value = function(input) {
					return com.mindrocks.text.ParseResult.Failure(com.mindrocks.text.FailureObj.newStack({ msg : error, pos : input.offset}),input,isError);
				};
			}
			return value;
		};
		return $r;
	}(this));
}
Parsers.success = function(v) {
	return (function($this) {
		var $r;
		var value = null;
		var computationRequested = false;
		$r = function() {
			if(!computationRequested) {
				computationRequested = true;
				value = function(input) {
					return com.mindrocks.text.ParseResult.Success(v,input);
				};
			}
			return value;
		};
		return $r;
	}(this));
}
Parsers.identity = function(p) {
	return p;
}
Parsers.andWith = function(p1,p2,f) {
	return (function($this) {
		var $r;
		var value = null;
		var computationRequested = false;
		$r = function() {
			if(!computationRequested) {
				computationRequested = true;
				value = function(input) {
					var res = (p1())(input);
					var $e = (res);
					switch( $e[1] ) {
					case 0:
						var res_eSuccess_1 = $e[3], res_eSuccess_0 = $e[2];
						var res1 = (p2())(res_eSuccess_1);
						var $e = (res1);
						switch( $e[1] ) {
						case 0:
							var res_eSuccess_11 = $e[3], res_eSuccess_01 = $e[2];
							return com.mindrocks.text.ParseResult.Success(f(res_eSuccess_0,res_eSuccess_01),res_eSuccess_11);
						case 1:
							var r = res1;
							return r;
						}
						break;
					case 1:
						var r = res;
						return r;
					}
				};
			}
			return value;
		};
		return $r;
	}(this));
}
Parsers.and = function(p1,p2) {
	return Parsers.andWith(p1,p2,com.mindrocks.functional.Tuples.t2);
}
Parsers.sndParam = function(_,b) {
	return b;
}
Parsers._and = function(p1,p2) {
	return Parsers.andWith(p1,p2,Parsers.sndParam);
}
Parsers.fstParam = function(a,_) {
	return a;
}
Parsers.and_ = function(p1,p2) {
	return Parsers.andWith(p1,p2,Parsers.fstParam);
}
Parsers.andThen = function(p1,fp2) {
	return (function($this) {
		var $r;
		var value = null;
		var computationRequested = false;
		$r = function() {
			if(!computationRequested) {
				computationRequested = true;
				value = function(input) {
					var res = (p1())(input);
					var $e = (res);
					switch( $e[1] ) {
					case 0:
						var res_eSuccess_1 = $e[3], res_eSuccess_0 = $e[2];
						return ((fp2(res_eSuccess_0))())(res_eSuccess_1);
					case 1:
						var r = res;
						return r;
					}
				};
			}
			return value;
		};
		return $r;
	}(this));
}
Parsers.then = function(p1,f) {
	return (function($this) {
		var $r;
		var value = null;
		var computationRequested = false;
		$r = function() {
			if(!computationRequested) {
				computationRequested = true;
				value = function(input) {
					var res = (p1())(input);
					var $e = (res);
					switch( $e[1] ) {
					case 0:
						var res_eSuccess_1 = $e[3], res_eSuccess_0 = $e[2];
						return com.mindrocks.text.ParseResult.Success(f(res_eSuccess_0),res_eSuccess_1);
					case 1:
						var r = res;
						return r;
					}
				};
			}
			return value;
		};
		return $r;
	}(this));
}
Parsers.forPredicate = function(pred) {
	return function(x) {
		return pred(x)?Parsers.success(x):Parsers.defaultFail;
	};
}
Parsers.filter = function(p,pred) {
	return Parsers.andThen(p,Parsers.forPredicate(pred));
}
Parsers.commit = function(p1) {
	return (function($this) {
		var $r;
		var value = null;
		var computationRequested = false;
		$r = function() {
			if(!computationRequested) {
				computationRequested = true;
				value = function(input) {
					var res = (p1())(input);
					var $e = (res);
					switch( $e[1] ) {
					case 0:
						return res;
					case 1:
						var res_eFailure_2 = $e[4], res_eFailure_1 = $e[3], res_eFailure_0 = $e[2];
						return res_eFailure_2 || com.mindrocks.functional.List.last(res_eFailure_0).msg == "Base Failure"?res:com.mindrocks.text.ParseResult.Failure(res_eFailure_0,res_eFailure_1,true);
					}
				};
			}
			return value;
		};
		return $r;
	}(this));
}
Parsers.or = function(p1,p2) {
	return (function($this) {
		var $r;
		var value = null;
		var computationRequested = false;
		$r = function() {
			if(!computationRequested) {
				computationRequested = true;
				value = function(input) {
					var res = (p1())(input);
					var $e = (res);
					switch( $e[1] ) {
					case 0:
						return res;
					case 1:
						var res_eFailure_2 = $e[4];
						return res_eFailure_2?res:(p2())(input);
					}
				};
			}
			return value;
		};
		return $r;
	}(this));
}
Parsers.ors = function(ps) {
	return (function($this) {
		var $r;
		var value = null;
		var computationRequested = false;
		$r = function() {
			if(!computationRequested) {
				computationRequested = true;
				value = function(input) {
					var pIndex = 0;
					while(pIndex < ps.length) {
						var res = (ps[pIndex]())(input);
						var $e = (res);
						switch( $e[1] ) {
						case 0:
							return res;
						case 1:
							var res_eFailure_2 = $e[4];
							if(res_eFailure_2 || ++pIndex == ps.length) return res;
							break;
						}
					}
					return com.mindrocks.text.ParseResult.Failure(com.mindrocks.text.FailureObj.newStack({ msg : "none match", pos : input.offset}),input,false);
				};
			}
			return value;
		};
		return $r;
	}(this));
}
Parsers.many = function(p1) {
	return (function($this) {
		var $r;
		var value = null;
		var computationRequested = false;
		$r = function() {
			if(!computationRequested) {
				computationRequested = true;
				value = function(input) {
					var parser = p1();
					var arr = [];
					var matches = true;
					while(matches) {
						var res = parser(input);
						var $e = (res);
						switch( $e[1] ) {
						case 0:
							var res_eSuccess_1 = $e[3], res_eSuccess_0 = $e[2];
							arr.push(res_eSuccess_0);
							input = res_eSuccess_1;
							break;
						case 1:
							var res_eFailure_2 = $e[4];
							if(res_eFailure_2) {
								var r = res;
								return r;
							} else matches = false;
							break;
						}
					}
					return com.mindrocks.text.ParseResult.Success(arr,input);
				};
			}
			return value;
		};
		return $r;
	}(this));
}
Parsers.notEmpty = function(arr) {
	return arr.length > 0;
}
Parsers.oneMany = function(p1) {
	return Parsers.andThen(Parsers.many(p1),Parsers.forPredicate(Parsers.notEmpty));
}
Parsers.rep1sep = function(p1,sep) {
	return Parsers.then(Parsers.andWith(p1,Parsers.many(Parsers.andWith(sep,p1,Parsers.sndParam)),com.mindrocks.functional.Tuples.t2),function(t) {
		t.b.splice(0,0,t.a);
		return t.b;
	});
}
Parsers.repsep = function(p1,sep) {
	return Parsers.or(Parsers.rep1sep(p1,sep),Parsers.success([]));
}
Parsers.chainl1 = function(p1,op) {
	var rest = (function($this) {
		var $r;
		var rest1 = null;
		rest1 = function(x) {
			return Parsers.or(Parsers.andThen(op,function(f) {
				return Parsers.andThen(p1,function(y) {
					return rest1(f(x,y));
				});
			}),Parsers.success(x));
		};
		$r = rest1;
		return $r;
	}(this));
	return Parsers.andThen(p1,rest);
}
Parsers.option = function(p1) {
	return Parsers.or(Parsers.then(p1,com.mindrocks.functional.Option.Some),Parsers.success(com.mindrocks.functional.Option.None));
}
Parsers.trace = function(p,f) {
	return Parsers.then(p,function(x) {
		haxe.Log.trace(f(x),{ fileName : "Parser.hx", lineNumber : 583, className : "com.mindrocks.text.Parsers", methodName : "trace"});
		return x;
	});
}
Parsers.identifier = function(x) {
	return (function($this) {
		var $r;
		var value = null;
		var computationRequested = false;
		$r = function() {
			if(!computationRequested) {
				computationRequested = true;
				value = function(input) {
					if(input.content.range(input.offset,x.length) == x) return com.mindrocks.text.ParseResult.Success(x,{ content : input.content, offset : input.offset + x.length, memo : input.memo}); else return com.mindrocks.text.ParseResult.Failure(com.mindrocks.text.FailureObj.newStack({ msg : x + " expected and not found", pos : input.offset}),input,false);
				};
			}
			return value;
		};
		return $r;
	}(this));
}
Parsers.regexParser = function(r) {
	return (function($this) {
		var $r;
		var value = null;
		var computationRequested = false;
		$r = function() {
			if(!computationRequested) {
				computationRequested = true;
				value = function(input) {
					return r.match(input.content.range(input.offset))?(function($this) {
						var $r;
						var pos = r.matchedPos();
						$r = pos.pos == 0?com.mindrocks.text.ParseResult.Success(input.content.range(input.offset,pos.len),{ content : input.content, offset : input.offset + pos.len, memo : input.memo}):com.mindrocks.text.ParseResult.Failure(com.mindrocks.text.FailureObj.newStack({ msg : Std.string(r) + "not matched at position " + input.offset, pos : input.offset}),input,false);
						return $r;
					}(this)):com.mindrocks.text.ParseResult.Failure(com.mindrocks.text.FailureObj.newStack({ msg : Std.string(r) + " not matched", pos : input.offset}),input,false);
				};
			}
			return value;
		};
		return $r;
	}(this));
}
Parsers.withError = function(p,f) {
	return (function($this) {
		var $r;
		var value = null;
		var computationRequested = false;
		$r = function() {
			if(!computationRequested) {
				computationRequested = true;
				value = function(input) {
					var r = (p())(input);
					var $e = (r);
					switch( $e[1] ) {
					case 1:
						var r_eFailure_2 = $e[4], r_eFailure_1 = $e[3], r_eFailure_0 = $e[2];
						return com.mindrocks.text.ParseResult.Failure(new com.mindrocks.functional.List({ msg : f(r_eFailure_0.get_head().msg), pos : r_eFailure_1.offset},r_eFailure_0),r_eFailure_1,r_eFailure_2);
					default:
						return r;
					}
				};
			}
			return value;
		};
		return $r;
	}(this));
}
Parsers.tag = function(p,tag) {
	return Parsers.withError(p,function(_) {
		return tag + " expected";
	});
}
com.mindrocks.functional.Tuples = function() { }
com.mindrocks.functional.Tuples.__name__ = ["com","mindrocks","functional","Tuples"];
com.mindrocks.functional.Tuples.t2 = function(a,b) {
	return { a : a, b : b};
}
com.mindrocks.functional.Option = { __ename__ : true, __constructs__ : ["None","Some"] }
com.mindrocks.functional.Option.None = ["None",0];
com.mindrocks.functional.Option.None.toString = $estr;
com.mindrocks.functional.Option.None.__enum__ = com.mindrocks.functional.Option;
com.mindrocks.functional.Option.Some = function(x) { var $x = ["Some",1,x]; $x.__enum__ = com.mindrocks.functional.Option; $x.toString = $estr; return $x; }
var js = {}
js.Boot = function() { }
js.Boot.__name__ = ["js","Boot"];
js.Boot.__unhtml = function(s) {
	return s.split("&").join("&amp;").split("<").join("&lt;").split(">").join("&gt;");
}
js.Boot.__trace = function(v,i) {
	var msg = i != null?i.fileName + ":" + i.lineNumber + ": ":"";
	msg += js.Boot.__string_rec(v,"");
	var d;
	if(typeof(document) != "undefined" && (d = document.getElementById("haxe:trace")) != null) d.innerHTML += js.Boot.__unhtml(msg) + "<br/>"; else if(typeof(console) != "undefined" && console.log != null) console.log(msg);
}
js.Boot.__string_rec = function(o,s) {
	if(o == null) return "null";
	if(s.length >= 5) return "<...>";
	var t = typeof(o);
	if(t == "function" && (o.__name__ || o.__ename__)) t = "object";
	switch(t) {
	case "object":
		if(o instanceof Array) {
			if(o.__enum__) {
				if(o.length == 2) return o[0];
				var str = o[0] + "(";
				s += "\t";
				var _g1 = 2, _g = o.length;
				while(_g1 < _g) {
					var i = _g1++;
					if(i != 2) str += "," + js.Boot.__string_rec(o[i],s); else str += js.Boot.__string_rec(o[i],s);
				}
				return str + ")";
			}
			var l = o.length;
			var i;
			var str = "[";
			s += "\t";
			var _g = 0;
			while(_g < l) {
				var i1 = _g++;
				str += (i1 > 0?",":"") + js.Boot.__string_rec(o[i1],s);
			}
			str += "]";
			return str;
		}
		var tostr;
		try {
			tostr = o.toString;
		} catch( e ) {
			return "???";
		}
		if(tostr != null && tostr != Object.toString) {
			var s2 = o.toString();
			if(s2 != "[object Object]") return s2;
		}
		var k = null;
		var str = "{\n";
		s += "\t";
		var hasp = o.hasOwnProperty != null;
		for( var k in o ) { ;
		if(hasp && !o.hasOwnProperty(k)) {
			continue;
		}
		if(k == "prototype" || k == "__class__" || k == "__super__" || k == "__interfaces__" || k == "__properties__") {
			continue;
		}
		if(str.length != 2) str += ", \n";
		str += s + k + " : " + js.Boot.__string_rec(o[k],s);
		}
		s = s.substring(1);
		str += "\n" + s + "}";
		return str;
	case "function":
		return "<function>";
	case "string":
		return o;
	default:
		return String(o);
	}
}
js.Boot.__interfLoop = function(cc,cl) {
	if(cc == null) return false;
	if(cc == cl) return true;
	var intf = cc.__interfaces__;
	if(intf != null) {
		var _g1 = 0, _g = intf.length;
		while(_g1 < _g) {
			var i = _g1++;
			var i1 = intf[i];
			if(i1 == cl || js.Boot.__interfLoop(i1,cl)) return true;
		}
	}
	return js.Boot.__interfLoop(cc.__super__,cl);
}
js.Boot.__instanceof = function(o,cl) {
	try {
		if(o instanceof cl) {
			if(cl == Array) return o.__enum__ == null;
			return true;
		}
		if(js.Boot.__interfLoop(o.__class__,cl)) return true;
	} catch( e ) {
		if(cl == null) return false;
	}
	switch(cl) {
	case Int:
		return Math.ceil(o%2147483648.0) === o;
	case Float:
		return typeof(o) == "number";
	case Bool:
		return o === true || o === false;
	case String:
		return typeof(o) == "string";
	case Dynamic:
		return true;
	default:
		if(o == null) return false;
		if(cl == Class && o.__name__ != null) return true; else null;
		if(cl == Enum && o.__ename__ != null) return true; else null;
		return o.__enum__ == cl;
	}
}
var Std = function() { }
Std.__name__ = ["Std"];
Std.string = function(s) {
	return js.Boot.__string_rec(s,"");
}
Std.parseInt = function(x) {
	var v = parseInt(x,10);
	if(v == 0 && (HxOverrides.cca(x,1) == 120 || HxOverrides.cca(x,1) == 88)) v = parseInt(x);
	if(isNaN(v)) return null;
	return v;
}
Std.parseFloat = function(x) {
	return parseFloat(x);
}
com.mindrocks.text.MemoObj = function() { }
com.mindrocks.text.MemoObj.__name__ = ["com","mindrocks","text","MemoObj"];
com.mindrocks.text.MemoObj.updateCacheAndGet = function(r,genKey,entry) {
	var key = genKey(r.offset);
	r.memo.memoEntries.set(key,entry);
	return entry;
}
com.mindrocks.text.MemoObj.getFromCache = function(r,genKey) {
	var key = genKey(r.offset);
	var res = r.memo.memoEntries.get(key);
	return res == null?com.mindrocks.functional.Option.None:com.mindrocks.functional.Option.Some(res);
}
com.mindrocks.text.MemoObj.getRecursionHead = function(r) {
	var res = r.memo.recursionHeads.get(r.offset + "");
	return res == null?com.mindrocks.functional.Option.None:com.mindrocks.functional.Option.Some(res);
}
com.mindrocks.text.MemoObj.setRecursionHead = function(r,head) {
	r.memo.recursionHeads.set(r.offset + "",head);
}
com.mindrocks.text.MemoObj.removeRecursionHead = function(r) {
	r.memo.recursionHeads.remove(r.offset + "");
}
com.mindrocks.text.MemoObj.forKey = function(m,key) {
	var value = m.memoEntries.get(key);
	if(value == null) return com.mindrocks.functional.Option.None; else return com.mindrocks.functional.Option.Some(value);
}
com.mindrocks.text.MemoEntry = { __ename__ : true, __constructs__ : ["MemoParsed","MemoLR"] }
com.mindrocks.text.MemoEntry.MemoParsed = function(ans) { var $x = ["MemoParsed",0,ans]; $x.__enum__ = com.mindrocks.text.MemoEntry; $x.toString = $estr; return $x; }
com.mindrocks.text.MemoEntry.MemoLR = function(lr) { var $x = ["MemoLR",1,lr]; $x.__enum__ = com.mindrocks.text.MemoEntry; $x.toString = $estr; return $x; }
com.mindrocks.functional.Functionnal = function() { }
com.mindrocks.functional.Functionnal.__name__ = ["com","mindrocks","functional","Functionnal"];
com.mindrocks.functional.Functionnal.get = function(o) {
	var $e = (o);
	switch( $e[1] ) {
	case 1:
		var o_eSome_0 = $e[2];
		return o_eSome_0;
	default:
		throw "Error Option get on None";
	}
}
com.mindrocks.text.ResultObj = function() { }
com.mindrocks.text.ResultObj.__name__ = ["com","mindrocks","text","ResultObj"];
com.mindrocks.text.ResultObj.castType = function(p) {
	return p;
}
com.mindrocks.text.ResultObj.posFromResult = function(p) {
	var $e = (p);
	switch( $e[1] ) {
	case 0:
		var p_eSuccess_1 = $e[3];
		return p_eSuccess_1;
	case 1:
		var p_eFailure_1 = $e[3];
		return p_eFailure_1;
	}
}
com.mindrocks.text.ResultObj.matchFromResult = function(p) {
	var $e = (p);
	switch( $e[1] ) {
	case 0:
		var p_eSuccess_0 = $e[2];
		return Std.string(p_eSuccess_0);
	case 1:
		return "";
	}
}
var LambdaTest = function() { }
LambdaTest.__name__ = ["LambdaTest"];
LambdaTest.maybeRet = function(p) {
	return Parsers.andWith(Parsers.option(LambdaTest.spacingOrRetP),p,Parsers.sndParam);
}
LambdaTest.withSpacing = function(p) {
	return (function($this) {
		var $r;
		var value = null;
		var computationRequested = false;
		$r = function() {
			if(!computationRequested) {
				computationRequested = true;
				value = (Parsers.andWith(LambdaTest.spacingP,p,Parsers.sndParam))();
			}
			return value;
		};
		return $r;
	}(this));
}
var LangParser = function() { }
LangParser.__name__ = ["LangParser"];
LangParser.tryParse = function(str,parser,withResult,output) {
	try {
		var res = haxe.Timer.measure(function() {
			return parser({ content : com.mindrocks.text.Tools.enumerable(str), offset : 0, memo : { memoEntries : new haxe.ds.StringMap(), recursionHeads : new haxe.ds.StringMap(), lrStack : com.mindrocks.functional.Nil._nil}});
		},{ fileName : "LangParser.hx", lineNumber : 181, className : "LangParser", methodName : "tryParse"});
		var $e = (res);
		switch( $e[1] ) {
		case 0:
			var res_eSuccess_1 = $e[3], res_eSuccess_0 = $e[2];
			var remaining = res_eSuccess_1.content.range(res_eSuccess_1.offset);
			if(StringTools.trim(remaining).length == 0) haxe.Log.trace("success!",{ fileName : "LangParser.hx", lineNumber : 187, className : "LangParser", methodName : "tryParse"}); else haxe.Log.trace("cannot parse " + remaining,{ fileName : "LangParser.hx", lineNumber : 189, className : "LangParser", methodName : "tryParse"});
			withResult(res_eSuccess_0);
			break;
		case 1:
			var res_eFailure_1 = $e[3], res_eFailure_0 = $e[2];
			var p = com.mindrocks.text.ReaderObj.textAround(res_eFailure_1);
			output(p.text);
			output(p.indicator);
			com.mindrocks.functional.List.map(res_eFailure_0,function(error) {
				output("Error at " + error.pos + " : " + error.msg);
			});
			break;
		}
	} catch( e ) {
		haxe.Log.trace("Error " + Std.string(e),{ fileName : "LangParser.hx", lineNumber : 203, className : "LangParser", methodName : "tryParse"});
	}
}
LangParser.langTest = function() {
	var toOutput = function(str) {
		haxe.Log.trace(StringTools.replace(str," ","_"),{ fileName : "LangParser.hx", lineNumber : 210, className : "LangParser", methodName : "langTest"});
	};
	LangParser.tryParse("\r\n      toto =\r\n        let\r\n          a = 56\r\n          b = d\r\n          v = a =>\r\n            let x = 12\r\n            in x\r\n          b = d\r\n        in\r\n          add c d          \r\n    ",LambdaTest.programP(),function(res) {
		haxe.Log.trace("Parsed " + Std.string(res),{ fileName : "LangParser.hx", lineNumber : 226, className : "LangParser", methodName : "langTest"});
	},toOutput);
}
var JsValue = { __ename__ : true, __constructs__ : ["JsObject","JsArray","JsData"] }
JsValue.JsObject = function(fields) { var $x = ["JsObject",0,fields]; $x.__enum__ = JsValue; $x.toString = $estr; return $x; }
JsValue.JsArray = function(elements) { var $x = ["JsArray",1,elements]; $x.__enum__ = JsValue; $x.toString = $estr; return $x; }
JsValue.JsData = function(x) { var $x = ["JsData",2,x]; $x.__enum__ = JsValue; $x.toString = $estr; return $x; }
var JsonPrettyPrinter = function() { }
JsonPrettyPrinter.__name__ = ["JsonPrettyPrinter"];
JsonPrettyPrinter.prettify = function(json) {
	return (function($this) {
		var $r;
		var internal = (function($this) {
			var $r;
			var internal1 = null;
			internal1 = function(json1) {
				return (function($this) {
					var $r;
					var $e = (json1);
					switch( $e[1] ) {
					case 0:
						var json_eJsObject_0 = $e[2];
						$r = "{\n" + json_eJsObject_0.map(function(field) {
							return field.name + " : " + internal1(field.value);
						}).join(",\n") + "\n}";
						break;
					case 1:
						var json_eJsArray_0 = $e[2];
						$r = "[\n" + json_eJsArray_0.map(internal1).join(",\n") + "\n]";
						break;
					case 2:
						var json_eJsData_0 = $e[2];
						$r = json_eJsData_0;
						break;
					}
					return $r;
				}(this));
			};
			$r = internal1;
			return $r;
		}($this));
		$r = internal(json);
		return $r;
	}(this));
}
var JsonParser = function() { }
JsonParser.__name__ = ["JsonParser"];
JsonParser.makeField = function(t) {
	return { name : t.a, value : t.b};
}
JsonParser.withSpacing = function(p) {
	return Parsers.andWith(JsonParser.spacingP,p,Parsers.sndParam);
}
var LRTest = function() { }
LRTest.__name__ = ["LRTest"];
var MonadParserTest = function() { }
MonadParserTest.__name__ = ["MonadParserTest"];
var ParserTest = function() { }
ParserTest.__name__ = ["ParserTest"];
ParserTest.expectFailure = function(s,parser,at) {
	var _g = parser({ content : com.mindrocks.text.Tools.enumerable(s), offset : 0, memo : { memoEntries : new haxe.ds.StringMap(), recursionHeads : new haxe.ds.StringMap(), lrStack : com.mindrocks.functional.Nil._nil}});
	var $e = (_g);
	switch( $e[1] ) {
	case 0:
		var _g_eSuccess_0 = $e[2];
		haxe.Log.trace(_g_eSuccess_0,{ fileName : "ParserTest.hx", lineNumber : 150, className : "ParserTest", methodName : "expectFailure"});
		haxe.Log.trace("unexpected success, result line above ",{ fileName : "ParserTest.hx", lineNumber : 151, className : "ParserTest", methodName : "expectFailure"});
		return false;
	case 1:
		var _g_eFailure_1 = $e[3], _g_eFailure_0 = $e[2];
		if(_g_eFailure_1.offset == at) return true; else {
			haxe.Log.trace("unexpected failure offset: " + com.mindrocks.text.ReaderObj.errorMessage(_g_eFailure_1,_g_eFailure_0),{ fileName : "ParserTest.hx", lineNumber : 157, className : "ParserTest", methodName : "expectFailure"});
			return false;
		}
		return true;
	}
}
ParserTest.expectSuccess = function(s,parser,result) {
	var _g = parser({ content : com.mindrocks.text.Tools.enumerable(s), offset : 0, memo : { memoEntries : new haxe.ds.StringMap(), recursionHeads : new haxe.ds.StringMap(), lrStack : com.mindrocks.functional.Nil._nil}});
	var $e = (_g);
	switch( $e[1] ) {
	case 0:
		var _g_eSuccess_0 = $e[2];
		if(Std.string(_g_eSuccess_0) == Std.string(result)) return true; else {
			haxe.Log.trace("result does not match: " + _g_eSuccess_0 + " expected :" + Std.string(result),{ fileName : "ParserTest.hx", lineNumber : 170, className : "ParserTest", methodName : "expectSuccess"});
			return false;
		}
		break;
	case 1:
		var _g_eFailure_1 = $e[3], _g_eFailure_0 = $e[2];
		haxe.Log.trace("unexpected failure : " + com.mindrocks.text.ReaderObj.errorMessage(_g_eFailure_1,_g_eFailure_0),{ fileName : "ParserTest.hx", lineNumber : 174, className : "ParserTest", methodName : "expectSuccess"});
		return false;
	}
}
ParserTest.jsonTest = function() {
	var ok = true;
	ok = ok && ParserTest.expectFailure(" {  aaa : aa, bbb :: [cc, dd] } ",JsonParser.jsonParser(),19);
	ok = ok && ParserTest.expectFailure("5++3+2+3",LRTest.expr(),2);
	ok = ok && ParserTest.expectSuccess("abc",MonadParserTest.parser(),["a","b","c"]);
	haxe.Log.trace(ok?"test passed ":"test FAILED!",{ fileName : "ParserTest.hx", lineNumber : 187, className : "ParserTest", methodName : "jsonTest"});
}
var StringBuf = function() {
	this.b = "";
};
StringBuf.__name__ = ["StringBuf"];
StringBuf.prototype = {
	__class__: StringBuf
}
var StringTools = function() { }
StringTools.__name__ = ["StringTools"];
StringTools.isSpace = function(s,pos) {
	var c = HxOverrides.cca(s,pos);
	return c > 8 && c < 14 || c == 32;
}
StringTools.ltrim = function(s) {
	var l = s.length;
	var r = 0;
	while(r < l && StringTools.isSpace(s,r)) r++;
	if(r > 0) return HxOverrides.substr(s,r,l - r); else return s;
}
StringTools.rtrim = function(s) {
	var l = s.length;
	var r = 0;
	while(r < l && StringTools.isSpace(s,l - r - 1)) r++;
	if(r > 0) return HxOverrides.substr(s,0,l - r); else return s;
}
StringTools.trim = function(s) {
	return StringTools.ltrim(StringTools.rtrim(s));
}
StringTools.lpad = function(s,c,l) {
	if(c.length <= 0) return s;
	while(s.length < l) s = c + s;
	return s;
}
StringTools.replace = function(s,sub,by) {
	return s.split(sub).join(by);
}
var Test = function() { }
Test.__name__ = ["Test"];
Test.main = function() {
	LangParser.langTest();
	ParserTest.jsonTest();
}
var ValueType = { __ename__ : true, __constructs__ : ["TNull","TInt","TFloat","TBool","TObject","TFunction","TClass","TEnum","TUnknown"] }
ValueType.TNull = ["TNull",0];
ValueType.TNull.toString = $estr;
ValueType.TNull.__enum__ = ValueType;
ValueType.TInt = ["TInt",1];
ValueType.TInt.toString = $estr;
ValueType.TInt.__enum__ = ValueType;
ValueType.TFloat = ["TFloat",2];
ValueType.TFloat.toString = $estr;
ValueType.TFloat.__enum__ = ValueType;
ValueType.TBool = ["TBool",3];
ValueType.TBool.toString = $estr;
ValueType.TBool.__enum__ = ValueType;
ValueType.TObject = ["TObject",4];
ValueType.TObject.toString = $estr;
ValueType.TObject.__enum__ = ValueType;
ValueType.TFunction = ["TFunction",5];
ValueType.TFunction.toString = $estr;
ValueType.TFunction.__enum__ = ValueType;
ValueType.TClass = function(c) { var $x = ["TClass",6,c]; $x.__enum__ = ValueType; $x.toString = $estr; return $x; }
ValueType.TEnum = function(e) { var $x = ["TEnum",7,e]; $x.__enum__ = ValueType; $x.toString = $estr; return $x; }
ValueType.TUnknown = ["TUnknown",8];
ValueType.TUnknown.toString = $estr;
ValueType.TUnknown.__enum__ = ValueType;
var Type = function() { }
Type.__name__ = ["Type"];
Type.getClassName = function(c) {
	var a = c.__name__;
	return a.join(".");
}
Type["typeof"] = function(v) {
	var _g = typeof(v);
	switch(_g) {
	case "boolean":
		return ValueType.TBool;
	case "string":
		return ValueType.TClass(String);
	case "number":
		if(Math.ceil(v) == v % 2147483648.0) return ValueType.TInt;
		return ValueType.TFloat;
	case "object":
		if(v == null) return ValueType.TNull;
		var e = v.__enum__;
		if(e != null) return ValueType.TEnum(e);
		var c = v.__class__;
		if(c != null) return ValueType.TClass(c);
		return ValueType.TObject;
	case "function":
		if(v.__name__ || v.__ename__) return ValueType.TObject;
		return ValueType.TFunction;
	case "undefined":
		return ValueType.TNull;
	default:
		return ValueType.TUnknown;
	}
}
com.mindrocks.macros = {}
com.mindrocks.macros.LazyMacro = function() { }
com.mindrocks.macros.LazyMacro.__name__ = ["com","mindrocks","macros","LazyMacro"];
com.mindrocks.macros.LazyMacro.alreadyLazy = function(type) {
	var $e = (type);
	switch( $e[1] ) {
	case 4:
		var type_eTFun_0 = $e[2];
		return type_eTFun_0.length == 0;
	case 7:
		var type_eTLazy_0 = $e[2];
		return com.mindrocks.macros.LazyMacro.alreadyLazy(type_eTLazy_0());
	default:
		return false;
	}
}
com.mindrocks.monads = {}
com.mindrocks.monads.MonadOp = { __ename__ : true, __constructs__ : [] }
com.mindrocks.monads.Option = { __ename__ : true, __constructs__ : ["None","Some"] }
com.mindrocks.monads.Option.None = ["None",0];
com.mindrocks.monads.Option.None.toString = $estr;
com.mindrocks.monads.Option.None.__enum__ = com.mindrocks.monads.Option;
com.mindrocks.monads.Option.Some = function(v) { var $x = ["Some",1,v]; $x.__enum__ = com.mindrocks.monads.Option; $x.toString = $estr; return $x; }
com.mindrocks.monads.Monad = function() { }
com.mindrocks.monads.Monad.__name__ = ["com","mindrocks","monads","Monad"];
com.mindrocks.monads.Monad.noOpt = function(m,position) {
	return m;
}
com.mindrocks.monads.Monad._dO = function(monadTypeName,body,context,optimize) {
}
com.mindrocks.text.Tools = function() { }
com.mindrocks.text.Tools.__name__ = ["com","mindrocks","text","Tools"];
com.mindrocks.text.Tools.enumerable = function(v) {
	var o = null;
	{
		var _g = Type["typeof"](v);
		var $e = (_g);
		switch( $e[1] ) {
		case 6:
			var _g_eTClass_0 = $e[2];
			var _g1 = Type.getClassName(_g_eTClass_0);
			switch(_g1) {
			case "Array":
				o = new com.mindrocks.text.ArrayEnumerable(v);
				break;
			case "String":
				o = new com.mindrocks.text.StringEnumerable(v);
				break;
			default:
				throw "no Enumerable found for " + Std.string(_g_eTClass_0);
			}
			break;
		default:
			throw "no Enumerable found for: " + Std.string(v);
		}
	}
	return o;
}
com.mindrocks.text.Tools.isSequencable = function(v) {
	return (function($this) {
		var $r;
		var _g = Type["typeof"](v);
		$r = (function($this) {
			var $r;
			var $e = (_g);
			switch( $e[1] ) {
			case 6:
				var _g_eTClass_0 = $e[2];
				$r = (function($this) {
					var $r;
					var _g1 = Type.getClassName(_g_eTClass_0);
					$r = (function($this) {
						var $r;
						switch(_g1) {
						case "Array":
							$r = true;
							break;
						case "String":
							$r = true;
							break;
						default:
							$r = false;
						}
						return $r;
					}($this));
					return $r;
				}($this));
				break;
			default:
				$r = false;
			}
			return $r;
		}($this));
		return $r;
	}(this));
}
com.mindrocks.text.Tools.isImmutable = function(x) {
	return x == null || js.Boot.__instanceof(x,Bool) || js.Boot.__instanceof(x,Float) || js.Boot.__instanceof(x,String);
}
com.mindrocks.text.Indexable = function(data,index) {
	if(index == null) index = 0;
	this.data = data;
	this.index = index;
};
com.mindrocks.text.Indexable.__name__ = ["com","mindrocks","text","Indexable"];
com.mindrocks.text.Indexable.prototype = {
	get_length: function() {
		throw "abstract method";
		return -1;
	}
	,at: function(i) {
		throw "abstract method";
		return null;
	}
	,__class__: com.mindrocks.text.Indexable
}
com.mindrocks.text.Enumerable = function(d,i) {
	com.mindrocks.text.Indexable.call(this,d,i);
};
com.mindrocks.text.Enumerable.__name__ = ["com","mindrocks","text","Enumerable"];
com.mindrocks.text.Enumerable.__super__ = com.mindrocks.text.Indexable;
com.mindrocks.text.Enumerable.prototype = $extend(com.mindrocks.text.Indexable.prototype,{
	range: function(loc,len) {
		throw "abstract function";
		return null;
	}
	,prepend: function(v) {
		throw "abstract function";
		return null;
	}
	,setIndex: function(i) {
		this.index = i;
		return this;
	}
	,hasNext: function() {
		return this.index < this.get_length();
	}
	,next: function() {
		var o = this.at(this.index);
		this.index++;
		return o;
	}
	,__class__: com.mindrocks.text.Enumerable
});
com.mindrocks.text.StringEnumerable = function(v,i) {
	com.mindrocks.text.Enumerable.call(this,v,i);
};
com.mindrocks.text.StringEnumerable.__name__ = ["com","mindrocks","text","StringEnumerable"];
com.mindrocks.text.StringEnumerable.__super__ = com.mindrocks.text.Enumerable;
com.mindrocks.text.StringEnumerable.prototype = $extend(com.mindrocks.text.Enumerable.prototype,{
	range: function(loc,len) {
		if(len == null) len = this.get_length() - loc;
		return HxOverrides.substr(this.data,loc,len);
	}
	,prepend: function(v) {
		var left = HxOverrides.substr(this.data,0,this.index);
		var right = HxOverrides.substr(this.data,this.index,null);
		return new com.mindrocks.text.StringEnumerable(this.data = left + v + right,this.index);
	}
	,get_length: function() {
		return this.data.length;
	}
	,at: function(i) {
		return this.data.charAt(this.index);
	}
	,__class__: com.mindrocks.text.StringEnumerable
});
com.mindrocks.text.ArrayEnumerable = function(v,i) {
	com.mindrocks.text.Enumerable.call(this,v,i);
};
com.mindrocks.text.ArrayEnumerable.__name__ = ["com","mindrocks","text","ArrayEnumerable"];
com.mindrocks.text.ArrayEnumerable.__super__ = com.mindrocks.text.Enumerable;
com.mindrocks.text.ArrayEnumerable.prototype = $extend(com.mindrocks.text.Enumerable.prototype,{
	range: function(loc,len) {
		len = len == null?this.get_length() - loc:len;
		return this.data.slice(loc,loc + len);
	}
	,prepend: function(v) {
		var out = this.data.slice();
		out.splice(this.index,0,v);
		return new com.mindrocks.text.ArrayEnumerable(out,this.index);
	}
	,get_length: function() {
		return this.data.length;
	}
	,at: function(i) {
		return this.data[i];
	}
	,__class__: com.mindrocks.text.ArrayEnumerable
});
com.mindrocks.text.StringIterator = function(data) {
	this.data = data;
	this.ln = data.length;
};
com.mindrocks.text.StringIterator.__name__ = ["com","mindrocks","text","StringIterator"];
com.mindrocks.text.StringIterator.prototype = {
	hasNext: function() {
		return this.index < this.ln;
	}
	,next: function() {
		var o = this.data.charAt(this.index);
		this.index++;
		return o;
	}
	,__class__: com.mindrocks.text.StringIterator
}
com.mindrocks.text.ParserObj = function() { }
com.mindrocks.text.ParserObj.__name__ = ["com","mindrocks","text","ParserObj"];
com.mindrocks.text.ParserObj.castType = function(p) {
	return p;
}
com.mindrocks.text.ReaderObj = function() { }
com.mindrocks.text.ReaderObj.__name__ = ["com","mindrocks","text","ReaderObj"];
com.mindrocks.text.ReaderObj.textAround = function(r,before,after) {
	if(after == null) after = 10;
	if(before == null) before = 10;
	var offset = Math.max(0,r.offset - before) | 0;
	var text = r.content.range(offset,before + after);
	var indicPadding = Math.min(r.offset,before) | 0;
	var indicator = StringTools.lpad("^","_",indicPadding + 1);
	return { text : text, indicator : indicator};
}
com.mindrocks.text.ReaderObj.errorMessage = function(r,msg) {
	var x = com.mindrocks.text.ReaderObj.textAround(r);
	var r1 = "";
	com.mindrocks.functional.List.each(msg,function(err) {
		r1 += "Error at " + err.pos + " : " + err.msg + "\n";
	});
	return r1 + " " + x.text + "\n" + x.indicator;
}
com.mindrocks.text.ReaderObj.position = function(r) {
	return r.offset;
}
com.mindrocks.text.ReaderObj.reader = function(str) {
	return { content : com.mindrocks.text.Tools.enumerable(str), offset : 0, memo : { memoEntries : new haxe.ds.StringMap(), recursionHeads : new haxe.ds.StringMap(), lrStack : com.mindrocks.functional.Nil._nil}};
}
com.mindrocks.text.ReaderObj.take = function(r,len) {
	return r.content.range(r.offset,len);
}
com.mindrocks.text.ReaderObj.drop = function(r,len) {
	return { content : r.content, offset : r.offset + len, memo : r.memo};
}
com.mindrocks.text.ReaderObj.startsWith = function(r,x) {
	return r.content.range(r.offset,x.length) == x;
}
com.mindrocks.text.ReaderObj.matchedBy = function(r,e) {
	return e.match(r.content.range(r.offset));
}
com.mindrocks.text.ReaderObj.rest = function(r) {
	return r.content.range(r.offset);
}
com.mindrocks.text.ParserM = function() { }
com.mindrocks.text.ParserM.__name__ = ["com","mindrocks","text","ParserM"];
com.mindrocks.text.ParserM.ret = function(v) {
	return Parsers.success(v);
}
com.mindrocks.text.ParserM.map = function(p1,f) {
	return Parsers.then(p1,f);
}
com.mindrocks.text.ParserM.flatMap = function(p1,fp2) {
	return Parsers.andThen(p1,fp2);
}
var haxe = {}
haxe.Log = function() { }
haxe.Log.__name__ = ["haxe","Log"];
haxe.Log.trace = function(v,infos) {
	js.Boot.__trace(v,infos);
}
haxe.Timer = function() { }
haxe.Timer.__name__ = ["haxe","Timer"];
haxe.Timer.measure = function(f,pos) {
	var t0 = haxe.Timer.stamp();
	var r = f();
	haxe.Log.trace(haxe.Timer.stamp() - t0 + "s",pos);
	return r;
}
haxe.Timer.stamp = function() {
	return new Date().getTime() / 1000;
}
haxe.ds = {}
haxe.ds.StringMap = function() {
	this.h = { };
};
haxe.ds.StringMap.__name__ = ["haxe","ds","StringMap"];
haxe.ds.StringMap.prototype = {
	toString: function() {
		var s = new StringBuf();
		s.b += "{";
		var it = this.keys();
		while( it.hasNext() ) {
			var i = it.next();
			s.b += Std.string(i);
			s.b += " => ";
			s.b += Std.string(Std.string(this.get(i)));
			if(it.hasNext()) s.b += ", ";
		}
		s.b += "}";
		return s.b;
	}
	,iterator: function() {
		return { ref : this.h, it : this.keys(), hasNext : function() {
			return this.it.hasNext();
		}, next : function() {
			var i = this.it.next();
			return this.ref["$" + i];
		}};
	}
	,keys: function() {
		var a = [];
		for( var key in this.h ) {
		if(this.h.hasOwnProperty(key)) a.push(key.substr(1));
		}
		return HxOverrides.iter(a);
	}
	,remove: function(key) {
		key = "$" + key;
		if(!this.h.hasOwnProperty(key)) return false;
		delete(this.h[key]);
		return true;
	}
	,exists: function(key) {
		return this.h.hasOwnProperty("$" + key);
	}
	,get: function(key) {
		return this.h["$" + key];
	}
	,set: function(key,value) {
		this.h["$" + key] = value;
	}
	,__class__: haxe.ds.StringMap
}
haxe.macro = {}
haxe.macro.Type = { __ename__ : true, __constructs__ : ["TMono","TEnum","TInst","TType","TFun","TAnonymous","TDynamic","TLazy","TAbstract"] }
haxe.macro.Type.TMono = function(t) { var $x = ["TMono",0,t]; $x.__enum__ = haxe.macro.Type; $x.toString = $estr; return $x; }
haxe.macro.Type.TEnum = function(t,params) { var $x = ["TEnum",1,t,params]; $x.__enum__ = haxe.macro.Type; $x.toString = $estr; return $x; }
haxe.macro.Type.TInst = function(t,params) { var $x = ["TInst",2,t,params]; $x.__enum__ = haxe.macro.Type; $x.toString = $estr; return $x; }
haxe.macro.Type.TType = function(t,params) { var $x = ["TType",3,t,params]; $x.__enum__ = haxe.macro.Type; $x.toString = $estr; return $x; }
haxe.macro.Type.TFun = function(args,ret) { var $x = ["TFun",4,args,ret]; $x.__enum__ = haxe.macro.Type; $x.toString = $estr; return $x; }
haxe.macro.Type.TAnonymous = function(a) { var $x = ["TAnonymous",5,a]; $x.__enum__ = haxe.macro.Type; $x.toString = $estr; return $x; }
haxe.macro.Type.TDynamic = function(t) { var $x = ["TDynamic",6,t]; $x.__enum__ = haxe.macro.Type; $x.toString = $estr; return $x; }
haxe.macro.Type.TLazy = function(f) { var $x = ["TLazy",7,f]; $x.__enum__ = haxe.macro.Type; $x.toString = $estr; return $x; }
haxe.macro.Type.TAbstract = function(t,params) { var $x = ["TAbstract",8,t,params]; $x.__enum__ = haxe.macro.Type; $x.toString = $estr; return $x; }
function $iterator(o) { if( o instanceof Array ) return function() { return HxOverrides.iter(o); }; return typeof(o.iterator) == 'function' ? $bind(o,o.iterator) : o.iterator; };
var $_;
function $bind(o,m) { var f = function(){ return f.method.apply(f.scope, arguments); }; f.scope = o; f.method = m; return f; };
String.prototype.__class__ = String;
String.__name__ = ["String"];
Array.prototype.__class__ = Array;
Array.__name__ = ["Array"];
Date.prototype.__class__ = Date;
Date.__name__ = ["Date"];
var Int = { __name__ : ["Int"]};
var Dynamic = { __name__ : ["Dynamic"]};
var Float = Number;
Float.__name__ = ["Float"];
var Bool = Boolean;
Bool.__ename__ = ["Bool"];
var Class = { __name__ : ["Class"]};
var Enum = { };
Math.__name__ = ["Math"];
Math.NaN = Number.NaN;
Math.NEGATIVE_INFINITY = Number.NEGATIVE_INFINITY;
Math.POSITIVE_INFINITY = Number.POSITIVE_INFINITY;
Math.isFinite = function(i) {
	return isFinite(i);
};
Math.isNaN = function(i) {
	return isNaN(i);
};
var q = window.jQuery;
js.JQuery = q;
com.mindrocks.functional.Nil._nil = new com.mindrocks.functional.Nil();
Parsers._parserUid = 0;
Parsers.baseFailure = "Base Failure";
Parsers.defaultFail = Parsers.fail("not matched",false);
LambdaTest.identifierR = new EReg("[a-zA-Z0-9_-]+","");
LambdaTest.numberR = new EReg("[-]*[0-9]+","");
LambdaTest.spaceP = (function($this) {
	var $r;
	var value = null;
	var computationRequested = false;
	$r = function() {
		if(!computationRequested) {
			computationRequested = true;
			value = (Parsers.identifier(" "))();
		}
		return value;
	};
	return $r;
}(this));
LambdaTest.tabP = (function($this) {
	var $r;
	var value = null;
	var computationRequested = false;
	$r = function() {
		if(!computationRequested) {
			computationRequested = true;
			value = (Parsers.identifier("\t"))();
		}
		return value;
	};
	return $r;
}(this));
LambdaTest.retP = (function($this) {
	var $r;
	var value = null;
	var computationRequested = false;
	$r = function() {
		if(!computationRequested) {
			computationRequested = true;
			value = (Parsers.or(Parsers.identifier("\r"),Parsers.identifier("\n")))();
		}
		return value;
	};
	return $r;
}(this));
LambdaTest.spacingP = (function($this) {
	var $r;
	var value = null;
	var computationRequested = false;
	$r = function() {
		if(!computationRequested) {
			computationRequested = true;
			value = (Parsers.many(Parsers.ors([Parsers.andThen(Parsers.many(LambdaTest.spaceP),Parsers.forPredicate(Parsers.notEmpty)),Parsers.andThen(Parsers.many(LambdaTest.tabP),Parsers.forPredicate(Parsers.notEmpty))])))();
		}
		return value;
	};
	return $r;
}(this));
LambdaTest.spacingOrRetP = (function($this) {
	var $r;
	var value = null;
	var computationRequested = false;
	$r = function() {
		if(!computationRequested) {
			computationRequested = true;
			value = (Parsers.many(Parsers.ors([Parsers.andThen(Parsers.many(LambdaTest.spaceP),Parsers.forPredicate(Parsers.notEmpty)),Parsers.andThen(Parsers.many(LambdaTest.tabP),Parsers.forPredicate(Parsers.notEmpty)),Parsers.andThen(Parsers.many(LambdaTest.retP),Parsers.forPredicate(Parsers.notEmpty))])))();
		}
		return value;
	};
	return $r;
}(this));
LambdaTest.stringStartP = LambdaTest.withSpacing(Parsers.identifier("\""));
LambdaTest.stringStopP = Parsers.identifier("\"");
LambdaTest.leftAccP = LambdaTest.withSpacing(Parsers.identifier("{"));
LambdaTest.rightAccP = LambdaTest.withSpacing(Parsers.identifier("}"));
LambdaTest.leftBracketP = LambdaTest.withSpacing(Parsers.identifier("["));
LambdaTest.rightBracketP = LambdaTest.withSpacing(Parsers.identifier("]"));
LambdaTest.sepP = LambdaTest.withSpacing(Parsers.identifier(":"));
LambdaTest.commaP = LambdaTest.withSpacing(Parsers.identifier(","));
LambdaTest.equalsP = LambdaTest.withSpacing(Parsers.identifier("="));
LambdaTest.arrowP = LambdaTest.withSpacing(Parsers.identifier("=>"));
LambdaTest.dotP = Parsers.identifier(".");
LambdaTest.identifierP = (function($this) {
	var $r;
	var value = null;
	var computationRequested = false;
	$r = function() {
		if(!computationRequested) {
			computationRequested = true;
			value = (Parsers.tag(LambdaTest.withSpacing(Parsers.regexParser(LambdaTest.identifierR)),"identifier"))();
		}
		return value;
	};
	return $r;
}(this));
LambdaTest.letP = (function($this) {
	var $r;
	var value = null;
	var computationRequested = false;
	$r = function() {
		if(!computationRequested) {
			computationRequested = true;
			value = (LambdaTest.withSpacing(Parsers.identifier("let")))();
		}
		return value;
	};
	return $r;
}(this));
LambdaTest.inP = (function($this) {
	var $r;
	var value = null;
	var computationRequested = false;
	$r = function() {
		if(!computationRequested) {
			computationRequested = true;
			value = (LambdaTest.withSpacing(Parsers.identifier("in")))();
		}
		return value;
	};
	return $r;
}(this));
LambdaTest.identP = (function($this) {
	var $r;
	var value = null;
	var computationRequested = false;
	$r = function() {
		if(!computationRequested) {
			computationRequested = true;
			value = (Parsers.tag(Parsers.then(LambdaTest.identifierP,function(id) {
				return RExpression.Ident(id);
			}),"identifier"))();
		}
		return value;
	};
	return $r;
}(this));
LambdaTest.numberP = Parsers.then(Parsers.regexParser(LambdaTest.numberR),function(n) {
	return PrimitiveType.Number(Std.parseInt(n));
});
LambdaTest.floatNumberP = Parsers.then(Parsers.andWith(Parsers.andWith(LambdaTest.numberP,LambdaTest.dotP,Parsers.fstParam),LambdaTest.numberP,com.mindrocks.functional.Tuples.t2),function(p) {
	return PrimitiveType.FloatNumber(Std.parseFloat(Std.string(p.a) + "." + Std.string(p.b)));
});
LambdaTest.primitiveP = (function($this) {
	var $r;
	var value = null;
	var computationRequested = false;
	$r = function() {
		if(!computationRequested) {
			computationRequested = true;
			value = (Parsers.tag(Parsers.then(Parsers.ors([LambdaTest.floatNumberP,LambdaTest.numberP]),RExpression.Primitive),"primitive"))();
		}
		return value;
	};
	return $r;
}(this));
LambdaTest.lambdaP = (function($this) {
	var $r;
	var value = null;
	var computationRequested = false;
	$r = function() {
		if(!computationRequested) {
			computationRequested = true;
			value = (Parsers.tag(Parsers.then(Parsers.andWith(Parsers.andWith(LambdaTest.identifierP,LambdaTest.arrowP,Parsers.fstParam),LambdaTest.maybeRet(Parsers.commit(LambdaTest.expressionP)),com.mindrocks.functional.Tuples.t2),function(p) {
				return RExpression.LambdaExpr(p.a,p.b);
			}),"lambda"))();
		}
		return value;
	};
	return $r;
}(this));
LambdaTest.applicationP = (function($this) {
	var $r;
	var value = null;
	var computationRequested = false;
	$r = function() {
		if(!computationRequested) {
			computationRequested = true;
			value = (Parsers.tag(Parsers.then(Parsers.andWith(LambdaTest.rExpressionP,LambdaTest.identifierP,com.mindrocks.functional.Tuples.t2),function(p) {
				return RExpression.Apply(p.a,p.b);
			}),"application"))();
		}
		return value;
	};
	return $r;
}(this));
LambdaTest.rExpressionP = (function($this) {
	var $r;
	var value = null;
	var computationRequested = false;
	$r = function() {
		if(!computationRequested) {
			computationRequested = true;
			value = (Parsers.tag(Parsers.memo(Parsers.ors([LambdaTest.lambdaP,LambdaTest.applicationP,LambdaTest.identP,LambdaTest.primitiveP])),"RExpression"))();
		}
		return value;
	};
	return $r;
}(this));
LambdaTest.letExpressionP = (function($this) {
	var $r;
	var value = null;
	var computationRequested = false;
	$r = function() {
		if(!computationRequested) {
			computationRequested = true;
			value = (Parsers.tag(Parsers.then(Parsers.andWith(Parsers.andWith(LambdaTest.identifierP,LambdaTest.equalsP,Parsers.fstParam),LambdaTest.maybeRet(Parsers.commit(LambdaTest.rExpressionP)),com.mindrocks.functional.Tuples.t2),function(p) {
				return { ident : p.a, expr : p.b};
			}),"let expression"))();
		}
		return value;
	};
	return $r;
}(this));
LambdaTest.expressionP = (function($this) {
	var $r;
	var value = null;
	var computationRequested = false;
	$r = function() {
		if(!computationRequested) {
			computationRequested = true;
			value = (Parsers.tag(Parsers.then(Parsers.andWith(Parsers.option(Parsers.andWith(LambdaTest.letP,Parsers.commit(Parsers.andWith(LambdaTest.maybeRet(Parsers.andWith(Parsers.rep1sep(LambdaTest.maybeRet(LambdaTest.letExpressionP),Parsers.or(LambdaTest.commaP,LambdaTest.retP)),Parsers.option(LambdaTest.commaP),Parsers.fstParam)),LambdaTest.maybeRet(LambdaTest.inP),Parsers.fstParam)),Parsers.sndParam)),LambdaTest.maybeRet(LambdaTest.rExpressionP),com.mindrocks.functional.Tuples.t2),function(p) {
				var lets = (function($this) {
					var $r;
					var $e = (p.a);
					switch( $e[1] ) {
					case 1:
						var p_fa_eSome_0 = $e[2];
						$r = p_fa_eSome_0;
						break;
					case 0:
						$r = [];
						break;
					}
					return $r;
				}(this));
				return { lets : lets, expr : p.b};
			}),"expression"))();
		}
		return value;
	};
	return $r;
}(this));
LambdaTest.definitionP = (function($this) {
	var $r;
	var value = null;
	var computationRequested = false;
	$r = function() {
		if(!computationRequested) {
			computationRequested = true;
			value = (Parsers.tag(Parsers.then(Parsers.andWith(Parsers.andWith(LambdaTest.maybeRet(LambdaTest.identifierP),LambdaTest.equalsP,Parsers.fstParam),LambdaTest.maybeRet(Parsers.commit(LambdaTest.expressionP)),com.mindrocks.functional.Tuples.t2),function(p) {
				return { name : p.a, expr : p.b};
			}),"definition"))();
		}
		return value;
	};
	return $r;
}(this));
LambdaTest.programP = (function($this) {
	var $r;
	var value = null;
	var computationRequested = false;
	$r = function() {
		if(!computationRequested) {
			computationRequested = true;
			value = (Parsers.commit(Parsers.tag(Parsers.many(LambdaTest.definitionP),"program")))();
		}
		return value;
	};
	return $r;
}(this));
JsonParser.identifierR = new EReg("[a-zA-Z0-9_-]+","");
JsonParser.spaceP = Parsers.identifier(" ");
JsonParser.tabP = Parsers.identifier("\t");
JsonParser.retP = Parsers.or(Parsers.identifier("\r"),Parsers.identifier("\n"));
JsonParser.spacingP = (function($this) {
	var $r;
	var value = null;
	var computationRequested = false;
	$r = function() {
		if(!computationRequested) {
			computationRequested = true;
			value = (Parsers.many(Parsers.ors([Parsers.andThen(Parsers.many(JsonParser.spaceP),Parsers.forPredicate(Parsers.notEmpty)),Parsers.andThen(Parsers.many(JsonParser.tabP),Parsers.forPredicate(Parsers.notEmpty)),Parsers.andThen(Parsers.many(JsonParser.retP),Parsers.forPredicate(Parsers.notEmpty))])))();
		}
		return value;
	};
	return $r;
}(this));
JsonParser.leftAccP = JsonParser.withSpacing(Parsers.identifier("{"));
JsonParser.rightAccP = JsonParser.withSpacing(Parsers.identifier("}"));
JsonParser.leftBracketP = JsonParser.withSpacing(Parsers.identifier("["));
JsonParser.rightBracketP = JsonParser.withSpacing(Parsers.identifier("]"));
JsonParser.sepP = JsonParser.withSpacing(Parsers.identifier(":"));
JsonParser.commaP = JsonParser.withSpacing(Parsers.identifier(","));
JsonParser.equalsP = JsonParser.withSpacing(Parsers.identifier(","));
JsonParser.identifierP = JsonParser.withSpacing(Parsers.regexParser(JsonParser.identifierR));
JsonParser.jsonDataP = Parsers.then(JsonParser.identifierP,JsValue.JsData);
JsonParser.jsonValueP = (function($this) {
	var $r;
	var value = null;
	var computationRequested = false;
	$r = function() {
		if(!computationRequested) {
			computationRequested = true;
			value = (Parsers.tag(Parsers.ors([JsonParser.jsonParser,JsonParser.jsonDataP,JsonParser.jsonArrayP]),"json value"))();
		}
		return value;
	};
	return $r;
}(this));
JsonParser.jsonArrayP2 = Parsers.then(Parsers.andWith(JsonParser.leftBracketP,Parsers.commit(Parsers.andWith(Parsers.repsep(JsonParser.jsonValueP,JsonParser.commaP),JsonParser.rightBracketP,Parsers.fstParam)),Parsers.sndParam),JsValue.JsArray);
JsonParser.jsonArrayPM = Parsers.then(Parsers.commit(Parsers.andThen(JsonParser.leftBracketP,function(_) {
	return Parsers.andThen(Parsers.repsep(JsonParser.jsonValueP,JsonParser.commaP),function(jsons) {
		return Parsers.then(JsonParser.rightBracketP,function(_1) {
			return jsons;
		});
	});
})),function(jsons) {
	return JsValue.JsArray(jsons);
});
JsonParser.jsonArrayP = Parsers.commit(Parsers.andThen(JsonParser.leftBracketP,function(_) {
	return Parsers.andThen(Parsers.repsep(JsonParser.jsonValueP,JsonParser.commaP),function(jsons) {
		return Parsers.then(JsonParser.rightBracketP,function(_1) {
			return JsValue.JsArray(jsons);
		});
	});
}));
JsonParser.jsonEntryP = Parsers.andWith(JsonParser.identifierP,Parsers.commit(Parsers.andWith(JsonParser.sepP,JsonParser.jsonValueP,Parsers.sndParam)),com.mindrocks.functional.Tuples.t2);
JsonParser.jsonEntriesP = Parsers.commit(Parsers.repsep(JsonParser.jsonEntryP,JsonParser.commaP));
JsonParser.jsonParser = Parsers.then(Parsers.andWith(Parsers.andWith(JsonParser.leftAccP,JsonParser.jsonEntriesP,Parsers.sndParam),Parsers.commit(JsonParser.rightAccP),Parsers.fstParam),function(entries) {
	return JsValue.JsObject(Lambda.array(entries.map(JsonParser.makeField)));
});
LRTest.posNumberR = new EReg("[0-9]+","");
LRTest.plusP = Parsers.identifier("+");
LRTest.posNumberP = Parsers.tag(Parsers.regexParser(LRTest.posNumberR),"number");
LRTest.binop = (function($this) {
	var $r;
	var value = null;
	var computationRequested = false;
	$r = function() {
		if(!computationRequested) {
			computationRequested = true;
			value = (Parsers.tag(Parsers.andWith(Parsers.andWith(LRTest.expr,LRTest.plusP,Parsers.fstParam),Parsers.commit(LRTest.expr),function(a,b) {
				return a + " + " + b;
			}),"binop"))();
		}
		return value;
	};
	return $r;
}(this));
LRTest.expr = Parsers.tag(Parsers.memo(Parsers.or(LRTest.binop,LRTest.posNumberP)),"expression");
MonadParserTest.parser = Parsers.andThen(Parsers.identifier("a"),function(a) {
	return Parsers.andThen(Parsers.identifier("b"),function(b) {
		return Parsers.then(Parsers.identifier("c"),function(c) {
			return [a,b,c];
		});
	});
});
com.mindrocks.monads.Monad.validNames = new haxe.ds.StringMap();
Test.main();
})();
