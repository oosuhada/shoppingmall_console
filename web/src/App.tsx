import { useEffect, useMemo, useState, type FormEvent } from 'react';
import {
  ArrowRight,
  Check,
  ChevronDown,
  Heart,
  KeyRound,
  LogOut,
  Minus,
  Plus,
  Search,
  ShoppingBag,
  Trash2,
  UserRound,
  X,
} from 'lucide-react';
import { Link, Route, Switch, useLocation } from 'wouter';

type ProductCategory = '상의' | '원피스' | '하의' | '액세서리';
type ProductSize = 'S' | 'M' | 'L' | 'Free';
type Product = {
  code: string;
  department: '여성' | '남성';
  category: ProductCategory;
  name: string;
  englishName: string;
  price: number;
  size: ProductSize;
  kind: 'shirt' | 'dress' | 'tee' | 'shorts' | 'socks';
  tone: string;
  note: string;
};
type Cart = Record<string, number>;
type Credentials = { id: string; password: string };

const PRODUCTS: Product[] = [
  { code: '001', department: '여성', category: '상의', name: '코튼 셔츠', englishName: 'Essential Cotton Shirt', price: 45000, size: 'M', kind: 'shirt', tone: 'clay', note: '가볍고 단정한 데일리 셔츠' },
  { code: '010', department: '여성', category: '원피스', name: '라인 원피스', englishName: 'Clean Line Dress', price: 50000, size: 'S', kind: 'dress', tone: 'sage', note: '하루의 실루엣을 정리하는 원피스' },
  { code: '122', department: '남성', category: '상의', name: '에센셜 티셔츠', englishName: 'Everyday Tee', price: 15000, size: 'L', kind: 'tee', tone: 'sand', note: '매일 꺼내 입기 좋은 기본 티셔츠' },
  { code: '131', department: '남성', category: '하의', name: '유틸리티 쇼츠', englishName: 'Utility Shorts', price: 38000, size: 'M', kind: 'shorts', tone: 'slate', note: '가벼운 움직임을 위한 미니멀 쇼츠' },
  { code: '142', department: '남성', category: '액세서리', name: '데일리 삭스', englishName: 'Daily Socks', price: 5000, size: 'Free', kind: 'socks', tone: 'rose', note: '작은 디테일까지 정돈하는 기본 양말' },
];

const DEFAULT_CREDENTIALS: Credentials = { id: 'user', password: 'password' };
const CART_KEY = 'oosu-mall-cart';
const CREDENTIALS_KEY = 'oosu-mall-credentials';
const SESSION_KEY = 'oosu-mall-session';

function formatPrice(price: number) {
  return `${price.toLocaleString('ko-KR')}원`;
}

function readStorage<T>(key: string, fallback: T): T {
  try {
    const value = localStorage.getItem(key);
    return value ? JSON.parse(value) as T : fallback;
  } catch {
    return fallback;
  }
}

function QuantityControl({ value, onChange, testId }: { value: number; onChange: (next: number) => void; testId: string }) {
  return (
    <div className="quantity-control" data-testid={`quantity-control-${testId}`}>
      <button type="button" aria-label="수량 줄이기" disabled={value <= 1} onClick={() => onChange(Math.max(1, value - 1))} data-testid={`button-decrease-${testId}`}><Minus size={14} /></button>
      <span data-testid={`text-quantity-${testId}`}>{value}</span>
      <button type="button" aria-label="수량 늘리기" disabled={value >= 10} onClick={() => onChange(Math.min(10, value + 1))} data-testid={`button-increase-${testId}`}><Plus size={14} /></button>
    </div>
  );
}

function ProductArtwork({ product, compact = false }: { product: Product; compact?: boolean }) {
  return (
    <div className={`product-art art-${product.tone} ${compact ? 'compact' : ''}`} data-testid={`art-product-${product.code}`}>
      <span className="art-index">{product.code}</span>
      <div className={`garment-wrap garment-${product.kind}`} aria-hidden="true">
        {product.kind === 'shirt' && <><span className="sleeve left" /><span className="garment-body" /><span className="sleeve right" /><span className="collar" /></>}
        {product.kind === 'dress' && <><span className="dress-top" /><span className="dress-skirt" /><span className="collar" /></>}
        {product.kind === 'tee' && <><span className="sleeve left" /><span className="garment-body tee" /><span className="sleeve right" /><span className="neck" /></>}
        {product.kind === 'shorts' && <><span className="waist" /><span className="short-leg left" /><span className="short-leg right" /></>}
        {product.kind === 'socks' && <><span className="sock first" /><span className="sock second" /></>}
      </div>
      {!compact && <span className="art-caption">OOSU / {product.category.toUpperCase()}</span>}
    </div>
  );
}

function Header({ cartCount, isLoggedIn }: { cartCount: number; isLoggedIn: boolean }) {
  const [location] = useLocation();
  return (
    <header className="site-header">
      <div className="header-inner">
        <Link href="/" className="wordmark" data-testid="link-logo">
          <span>Oosu Mall</span>
          <small>우수몰</small>
        </Link>
        <nav className="desktop-nav" aria-label="주요 메뉴">
          <Link href="/" className={location === '/' ? 'active' : ''} data-testid="link-home">Shop</Link>
          <Link href="/cart" className={location === '/cart' ? 'active' : ''} data-testid="link-cart-nav">Cart</Link>
          <Link href="/account" className={location === '/account' ? 'active' : ''} data-testid="link-account-nav">Account</Link>
        </nav>
        <div className="header-actions">
          <Link href="/account" className="header-icon" aria-label="계정" data-testid="link-account-icon"><UserRound size={18} />{isLoggedIn && <span className="session-dot" />}</Link>
          <Link href="/cart" className="header-icon cart-icon" aria-label="장바구니" data-testid="link-cart-icon"><ShoppingBag size={18} />{cartCount > 0 && <span className="cart-count" data-testid="badge-cart-count">{cartCount}</span>}</Link>
        </div>
      </div>
      <nav className="mobile-nav" aria-label="모바일 메뉴">
        <Link href="/" className={location === '/' ? 'active' : ''}>Shop</Link>
        <Link href="/cart" className={location === '/cart' ? 'active' : ''}>Cart {cartCount > 0 ? `(${cartCount})` : ''}</Link>
        <Link href="/account" className={location === '/account' ? 'active' : ''}>Account</Link>
      </nav>
    </header>
  );
}

function Footer() {
  return (
    <footer className="site-footer">
      <div><strong>Oosu Mall · 우수몰</strong><p>Original Dart console logic, reinterpreted as a browser portfolio storefront.</p></div>
      <a href="https://github.com/oosuhada/shoppingmall_console" target="_blank" rel="noreferrer">View original Dart project ↗</a>
    </footer>
  );
}

function Storefront({ cart, addToCart, notify }: { cart: Cart; addToCart: (product: Product, quantity: number) => void; notify: (message: string) => void }) {
  const [department, setDepartment] = useState<'all' | '여성' | '남성'>('all');
  const [category, setCategory] = useState<'all' | ProductCategory>('all');
  const [size, setSize] = useState<'all' | ProductSize>('all');
  const [query, setQuery] = useState('');
  const [draftQuantities, setDraftQuantities] = useState<Record<string, number>>({});
  const [favorites, setFavorites] = useState<Record<string, boolean>>({});

  const visibleProducts = useMemo(() => PRODUCTS.filter((product) => {
    const matchesDepartment = department === 'all' || product.department === department;
    const matchesCategory = category === 'all' || product.category === category;
    const matchesSize = size === 'all' || product.size === size;
    const haystack = `${product.department} ${product.category} ${product.name} ${product.englishName} ${product.note}`.toLowerCase();
    return matchesDepartment && matchesCategory && matchesSize && haystack.includes(query.toLowerCase());
  }), [department, category, size, query]);

  const toggleFavorite = (product: Product) => {
    const next = !favorites[product.code];
    setFavorites((current) => ({ ...current, [product.code]: next }));
    notify(next ? `${product.name}을 위시리스트에 담았어요.` : `${product.name}을 위시리스트에서 뺐어요.`);
  };

  return (
    <main>
      <section className="hero-section">
        <div className="hero-copy">
          <p className="eyebrow">OOSU EDIT / 2026 · BROWSER COLLECTION</p>
          <h1>입는 순간이<br /><em>더 선명하게.</em></h1>
          <p className="hero-description">초기 Dart 콘솔 쇼핑몰의 상품 탐색과 장바구니 흐름을, 지금의 포트폴리오에 어울리는 작은 패션 스토어로 다시 구성했습니다.</p>
          <div className="hero-actions"><a href="#collection" className="button primary">컬렉션 보기 <ArrowRight size={16} /></a><Link href="/cart" className="button secondary">장바구니 확인</Link></div>
        </div>
        <div className="hero-editorial" aria-hidden="true">
          <div className="hero-look"><span className="hero-look-top" /><span className="hero-look-bottom" /></div>
          <p>LESS NOISE<br />MORE FORM</p>
          <span>01 / 05</span>
        </div>
      </section>

      <section id="collection" className="collection-section">
        <div className="section-heading">
          <div><p className="eyebrow">CURATED 05</p><h2>Oosu Essentials</h2></div>
          <p>필요한 기능은 남기고, 선택은 더 간결하게.</p>
        </div>

        <div className="filter-bar" data-testid="product-filters">
          <div className="filter-group" aria-label="성별 필터">{(['all', '여성', '남성'] as const).map((item) => <button key={item} type="button" className={department === item ? 'active' : ''} onClick={() => setDepartment(item)} data-testid={`button-department-${item}`}>{item === 'all' ? '전체' : item}</button>)}</div>
          <label className="select-filter">Category<ChevronDown size={13} /><select value={category} onChange={(event) => setCategory(event.target.value as 'all' | ProductCategory)} data-testid="select-category"><option value="all">전체 카테고리</option><option value="상의">상의</option><option value="원피스">원피스</option><option value="하의">하의</option><option value="액세서리">액세서리</option></select></label>
          <label className="select-filter">Size<ChevronDown size={13} /><select value={size} onChange={(event) => setSize(event.target.value as 'all' | ProductSize)} data-testid="select-size"><option value="all">전체 사이즈</option><option value="S">S</option><option value="M">M</option><option value="L">L</option><option value="Free">Free</option></select></label>
          <label className="search-field"><Search size={15} /><input value={query} onChange={(event) => setQuery(event.target.value)} placeholder="상품 검색" aria-label="상품 검색" data-testid="input-product-search" /></label>
        </div>

        <div className="result-meta"><span>{visibleProducts.length} products</span>{(department !== 'all' || category !== 'all' || size !== 'all' || query) && <button type="button" onClick={() => { setDepartment('all'); setCategory('all'); setSize('all'); setQuery(''); }} data-testid="button-reset-filters">필터 초기화</button>}</div>

        {visibleProducts.length ? (
          <div className="product-grid">
            {visibleProducts.map((product) => {
              const selectedQuantity = draftQuantities[product.code] ?? 1;
              return (
                <article className="product-card" key={product.code} data-testid={`card-product-${product.code}`}>
                  <div className="product-visual-wrap"><ProductArtwork product={product} /><button type="button" className={`favorite-button ${favorites[product.code] ? 'active' : ''}`} aria-label={`${product.name} 찜하기`} onClick={() => toggleFavorite(product)} data-testid={`button-favorite-${product.code}`}><Heart size={17} fill={favorites[product.code] ? 'currentColor' : 'none'} /></button></div>
                  <div className="product-info">
                    <div className="product-heading"><div><p>{product.department} / {product.category}</p><h3 data-testid={`text-product-name-${product.code}`}>{product.name}</h3><span>{product.englishName}</span></div><strong data-testid={`text-product-price-${product.code}`}>{formatPrice(product.price)}</strong></div>
                    <p className="product-note">{product.note}</p>
                    <div className="product-options"><span className="size-chip">SIZE {product.size}</span><QuantityControl value={selectedQuantity} onChange={(next) => setDraftQuantities((current) => ({ ...current, [product.code]: next }))} testId={`product-${product.code}`} /></div>
                    <button type="button" className="add-button" onClick={() => addToCart(product, selectedQuantity)} data-testid={`button-add-cart-${product.code}`}>{cart[product.code] ? `장바구니에 ${cart[product.code]}개 담김` : '장바구니에 담기'} <Plus size={16} /></button>
                  </div>
                </article>
              );
            })}
          </div>
        ) : (
          <div className="empty-state" data-testid="empty-product-search"><Search size={24} /><h3>조건에 맞는 상품이 없습니다.</h3><p>필터를 바꾸거나 검색어를 지우고 다시 둘러보세요.</p><button className="button secondary" onClick={() => { setDepartment('all'); setCategory('all'); setSize('all'); setQuery(''); }}>전체 상품 보기</button></div>
        )}
      </section>

      <section className="principles"><div><span>01</span><strong>Browse simply</strong><p>성별, 카테고리, 사이즈와 검색으로 작은 컬렉션을 빠르게 좁힙니다.</p></div><div><span>02</span><strong>Keep the state</strong><p>장바구니와 계정 상태는 브라우저 localStorage에만 저장됩니다.</p></div><div><span>03</span><strong>Trace the origin</strong><p>브라우저 데모는 초기 Dart CLI의 상태 변경 흐름을 재해석한 포트폴리오 버전입니다.</p></div></section>
    </main>
  );
}

function CartPage({ cart, setCart, notify, isLoggedIn }: { cart: Cart; setCart: (cart: Cart) => void; notify: (message: string) => void; isLoggedIn: boolean }) {
  const [, setLocation] = useLocation();
  const [checkoutDone, setCheckoutDone] = useState(false);
  const cartProducts = PRODUCTS.filter((product) => cart[product.code]);
  const totalItems = Object.values(cart).reduce((sum, quantity) => sum + quantity, 0);
  const totalPrice = cartProducts.reduce((sum, product) => sum + product.price * (cart[product.code] ?? 0), 0);

  const updateQuantity = (product: Product, quantity: number) => setCart({ ...cart, [product.code]: Math.max(1, Math.min(10, quantity)) });
  const removeProduct = (product: Product) => {
    const next = { ...cart };
    delete next[product.code];
    setCart(next);
    notify(`${product.name}을 장바구니에서 삭제했어요.`);
  };
  const checkout = () => {
    if (!isLoggedIn) {
      notify('주문 데모를 계속하려면 먼저 로그인해 주세요.');
      window.setTimeout(() => setLocation('/account'), 350);
      return;
    }
    setCheckoutDone(true);
  };

  return (
    <main className="page-shell">
      <div className="page-heading"><p className="eyebrow">YOUR SELECTION / {String(totalItems).padStart(2, '0')}</p><h1>Cart</h1><p>선택한 상품과 수량, 합계를 한 화면에서 정리합니다.</p></div>
      {cartProducts.length === 0 ? (
        <div className="empty-state cart-empty" data-testid="empty-cart-state"><ShoppingBag size={28} /><h2>장바구니가 비어 있습니다.</h2><p>컬렉션에서 필요한 아이템을 골라보세요.</p><Link href="/" className="button primary" data-testid="link-empty-cart-shop">쇼핑 계속하기 <ArrowRight size={16} /></Link></div>
      ) : (
        <div className="cart-layout">
          <section className="cart-list">
            <div className="cart-list-head"><span>{totalItems} items</span><button type="button" onClick={() => { setCart({}); notify('장바구니를 비웠어요.'); }} data-testid="button-clear-cart">전체 삭제</button></div>
            {cartProducts.map((product) => (
              <article className="cart-row" key={product.code} data-testid={`row-cart-${product.code}`}>
                <ProductArtwork product={product} compact />
                <div className="cart-product-copy"><p>{product.department} / {product.category}</p><h2 data-testid={`text-cart-name-${product.code}`}>{product.name}</h2><span>{product.englishName}</span><small>SIZE {product.size} · {formatPrice(product.price)}</small></div>
                <QuantityControl value={cart[product.code]} onChange={(next) => updateQuantity(product, next)} testId={`cart-${product.code}`} />
                <strong className="line-total" data-testid={`text-line-total-${product.code}`}>{formatPrice(product.price * cart[product.code])}</strong>
                <button className="remove-button" type="button" aria-label={`${product.name} 삭제`} onClick={() => removeProduct(product)} data-testid={`button-remove-cart-${product.code}`}><Trash2 size={16} /></button>
              </article>
            ))}
          </section>
          <aside className="cart-summary" data-testid="panel-cart-summary">
            <p className="summary-label">ORDER SUMMARY</p><h2>이번 선택</h2>
            <div className="summary-lines"><p><span>상품 수</span><strong data-testid="text-total-items">{totalItems}개</strong></p><p><span>배송</span><strong>Portfolio demo</strong></p></div>
            <div className="summary-total"><span>Total</span><strong data-testid="text-total-price">{formatPrice(totalPrice)}</strong></div>
            {checkoutDone ? <div className="checkout-complete" data-testid="status-checkout-complete"><Check size={18} /><strong>주문 흐름 확인 완료</strong><p>이 포트폴리오 데모는 실제 결제 없이 여기까지 진행됩니다.</p></div> : <button className="checkout-button" type="button" onClick={checkout} data-testid="button-checkout">주문 데모 계속하기 <ArrowRight size={16} /></button>}
            <p className="summary-note">상품별 최대 10개 · 결제 정보는 수집하지 않습니다.</p>
          </aside>
        </div>
      )}
    </main>
  );
}

function AccountPage({ credentials, setCredentials, isLoggedIn, setLoggedIn, notify }: { credentials: Credentials; setCredentials: (credentials: Credentials) => void; isLoggedIn: boolean; setLoggedIn: (value: boolean) => void; notify: (message: string) => void }) {
  const [id, setId] = useState('');
  const [password, setPassword] = useState('');
  const [currentPassword, setCurrentPassword] = useState('');
  const [newId, setNewId] = useState(credentials.id);
  const [newPassword, setNewPassword] = useState('');
  const [message, setMessage] = useState('');
  const [changed, setChanged] = useState(false);

  const login = (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    if (id.trim() === credentials.id && password === credentials.password) {
      setLoggedIn(true); setMessage(''); notify(`${credentials.id}님, 로그인했습니다.`);
    } else setMessage('아이디 또는 비밀번호를 다시 확인해 주세요.');
  };
  const updateCredentials = (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    if (currentPassword !== credentials.password) { setMessage('현재 비밀번호가 맞지 않습니다.'); return; }
    if (!newId.trim() || newPassword.length < 4) { setMessage('새 아이디와 4자 이상의 비밀번호를 입력해 주세요.'); return; }
    setCredentials({ id: newId.trim(), password: newPassword }); setCurrentPassword(''); setNewPassword(''); setMessage(''); setChanged(true); notify('계정 정보를 변경했습니다.');
  };

  return (
    <main className="page-shell account-page">
      <div className="account-intro"><p className="eyebrow">LOCAL ACCOUNT / BROWSER ONLY</p><h1>Account</h1><p>원래 콘솔 프로젝트의 로그인·계정 변경 흐름을 브라우저 상태로 재구성했습니다. 입력한 정보는 이 브라우저에만 저장됩니다.</p></div>
      <div className="account-layout">
        <section className="account-panel">
          {isLoggedIn ? (
            <><div className="account-status"><span><Check size={16} /></span><div><p>LOGGED IN</p><h2><strong data-testid="text-account-id">{credentials.id}</strong>님, 안녕하세요.</h2></div></div>
            <form onSubmit={updateCredentials} className="account-form"><div className="form-heading"><span>CHANGE CREDENTIALS</span><h3>계정 정보 변경</h3></div><Field label="현재 비밀번호" type="password" value={currentPassword} onChange={setCurrentPassword} testId="input-current-password" /><Field label="새 아이디" value={newId} onChange={setNewId} testId="input-new-id" /><Field label="새 비밀번호" type="password" value={newPassword} onChange={setNewPassword} testId="input-new-password" />{message && <p className="form-error" data-testid="status-account-error">{message}</p>}{changed && !message && <p className="form-success" data-testid="status-credentials-changed"><Check size={14} />변경한 정보가 저장되었습니다.</p>}<div className="form-actions"><button className="button primary" type="submit" data-testid="button-save-credentials">변경 저장</button><button className="button secondary" type="button" onClick={() => { setLoggedIn(false); notify('로그아웃했습니다.'); }} data-testid="button-logout"><LogOut size={15} />로그아웃</button></div></form></>
          ) : (
            <div className="login-wrap"><p className="eyebrow">WELCOME TO OOSU MALL</p><h2>로그인하고<br />선택을 이어가세요.</h2><p>장바구니는 로그인 전에도 유지됩니다. 주문 데모 단계에서 계정 상태를 확인합니다.</p><form onSubmit={login} className="account-form"><Field label="아이디" value={id} onChange={setId} testId="input-login-id" /><Field label="비밀번호" type="password" value={password} onChange={setPassword} testId="input-login-password" />{message && <p className="form-error" data-testid="status-login-error">{message}</p>}<button className="button primary full" type="submit" data-testid="button-login">로그인 <ArrowRight size={16} /></button></form><div className="demo-credentials"><KeyRound size={15} /><div><strong>Demo account</strong><p><span>user</span> / <span>password</span></p></div></div></div>
          )}
        </section>
        <aside className="account-editorial"><span>OOSU / 05</span><h2>Good design<br />keeps the<br /><em>choice clear.</em></h2><p>상품을 고르고, 상태를 바꾸고, 다시 돌아오는 흐름까지. 작은 콘솔 과제를 실제 제품처럼 읽히게 확장한 브라우저 데모입니다.</p></aside>
      </div>
    </main>
  );
}

function Field({ label, type = 'text', value, onChange, testId }: { label: string; type?: string; value: string; onChange: (value: string) => void; testId: string }) {
  return <label className="field-label"><span>{label}</span><input type={type} value={value} onChange={(event) => onChange(event.target.value)} data-testid={testId} /></label>;
}

function NotFoundPage() {
  return <main className="page-shell"><div className="empty-state not-found"><span>404</span><h1>찾는 페이지가 없습니다.</h1><p>Oosu Mall 컬렉션으로 돌아가 다시 둘러보세요.</p><Link href="/" className="button primary">스토어로 돌아가기</Link></div></main>;
}

function App() {
  const [cart, setCart] = useState<Cart>(() => readStorage(CART_KEY, {}));
  const [credentials, setCredentials] = useState<Credentials>(() => readStorage(CREDENTIALS_KEY, DEFAULT_CREDENTIALS));
  const [isLoggedIn, setLoggedIn] = useState<boolean>(() => readStorage(SESSION_KEY, false));
  const [notice, setNotice] = useState('');

  useEffect(() => { localStorage.setItem(CART_KEY, JSON.stringify(cart)); }, [cart]);
  useEffect(() => { localStorage.setItem(CREDENTIALS_KEY, JSON.stringify(credentials)); }, [credentials]);
  useEffect(() => { localStorage.setItem(SESSION_KEY, JSON.stringify(isLoggedIn)); }, [isLoggedIn]);
  useEffect(() => {
    if (!notice) return;
    const timer = window.setTimeout(() => setNotice(''), 2800);
    return () => window.clearTimeout(timer);
  }, [notice]);

  const addToCart = (product: Product, quantity: number) => {
    const current = cart[product.code] ?? 0;
    if (current + quantity > 10) { setNotice(`상품별 최대 10개까지 담을 수 있습니다. 현재 ${current}개가 담겨 있어요.`); return; }
    setCart({ ...cart, [product.code]: current + quantity });
    setNotice(`${product.name} ${quantity}개를 장바구니에 담았습니다.`);
  };
  const cartCount = Object.values(cart).reduce((sum, quantity) => sum + quantity, 0);

  return (
    <div className="app-shell">
      <Header cartCount={cartCount} isLoggedIn={isLoggedIn} />
      <Switch>
        <Route path="/"><Storefront cart={cart} addToCart={addToCart} notify={setNotice} /></Route>
        <Route path="/cart"><CartPage cart={cart} setCart={setCart} notify={setNotice} isLoggedIn={isLoggedIn} /></Route>
        <Route path="/account"><AccountPage credentials={credentials} setCredentials={setCredentials} isLoggedIn={isLoggedIn} setLoggedIn={setLoggedIn} notify={setNotice} /></Route>
        <Route><NotFoundPage /></Route>
      </Switch>
      <Footer />
      {notice && <div className="toast" role="status" data-testid="status-toast"><span>{notice}</span><button type="button" onClick={() => setNotice('')} aria-label="알림 닫기"><X size={15} /></button></div>}
    </div>
  );
}

export default App;
